const SerialPort = require('serialport')
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
  if (readedCards.length > 0) {
    readedCards.shift()
  }
},20000)

SerialPort.list().then(ports => {
  ports.filter(port => {
    if (port.manufacturer === 'Prolific') {
      const comPort = new SerialPort(port.path).setEncoding('hex')
      readCard(comPort)
    }
  })
}).catch(error => console.log('Chyba pri hľadaní čítačky kariet !'))


function readCard (comPort) {
  let tmpData = ''
  comPort.on('data', function (data) {
    if(!disabledHex.includes(data)){
      tmpData += String.fromCharCode(parseInt(data,16))
      if (tmpData.length === 10) {
        cardNo = tmpData.substr(2,tmpData.length)
        tmpData = ''
      }
    }
  })
}

server.listen(8088, function () {
  console.log('%s listening at %s', server.name, server.url)
})

