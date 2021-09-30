const SerialPort = require('serialport')
const Delimiter = require('@serialport/parser-delimiter')
const restify = require('restify')
const corsMiddleware = require('restify-cors-middleware')
const server = restify.createServer()
const disabledHex = ['02','0d','0a','1b','07']
let cardNo = 'empty_data'
let readedCards = []

const cors = corsMiddleware({
  origins: ['*'],
  allowHeaders: ['Origin', 'X-Requested-With', 'Content-Type', 'Accept']
})

server.pre(cors.preflight)
server.use(cors.actual)
server.use(restify.plugins.bodyParser())

server.get('/entry-point/test', function (req, res, next) {
  if (!readedCards.includes(cardNo) && cardNo !== 'empty_data') {
    readedCards.push(cardNo)
  } else {
    cardNo = 'empty_data'
  }
  let jsonString = { read: cardNo}
  res.send(jsonString)
  return next()
})

setInterval(function () {
  console.log(readedCards)
  if (readedCards.length > 0) {
    readedCards.shift()
  }
},20000)

function hex2a(hexx) {
  const hex = hexx.toString();//force conversion
  let str = '';
  for (let i = 0; i < hex.length; i += 2)
    str += String.fromCharCode(parseInt(hex.substr(i, 2), 16));
  return str;
}

const comPort = new SerialPort('/dev/ttyUSB0').setEncoding('hex')
readParser(comPort)

function readParser (comPort) {
  let tmpData = ''
  const parser = comPort.pipe(new Delimiter({ delimiter: '1b' }))
  parser.on('data', function (data) {
    cardNo = hex2a(data).substr(3,8)
  })
}

server.listen(8088, function () {
  console.log('%s listening at %s', server.name, server.url)
})
