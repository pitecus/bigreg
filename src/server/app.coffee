express = require 'express'
path = require 'path'

# Logger
morgan  = require 'morgan'

# Express 4.x
app = express()

# Values are 'default', 'short', 'tiny', 'dev'
app.use morgan 'dev'

# Static files.
app.use '/', express.static path.join __dirname, '../web'
console.log path.join __dirname, '../web'

app.get '/hi', (req, res) ->
  res.send 'hello world'



app.listen 3000