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

# A simple http response.
app.get '/hi', (req, res) ->
  res.send 'hello world'

# Listen on port 3000 by default.
app.listen 3000