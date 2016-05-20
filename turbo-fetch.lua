--[[
The MIT License (MIT)
Copyright (c) 2016 olueiro <github.com/olueiro>
Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
]]

return function(turbo, url, kwargs, callback, ssl_options, io_loop, max_buffer_size)
  local HTTPClient = turbo.async.HTTPClient(ssl_options, io_loop, max_buffer_size)
  local HTTPResponse
  HTTPClient.b_connect = HTTPClient._connect
  HTTPClient._connect = function()
      HTTPClient.in_progress = false
      if HTTPClient.coctx.co_args then
          HTTPClient.coctx:set_state(0x1)
          -- HTTPClient.coctx:finalize_context()
          HTTPClient.coctx = setmetatable({
              set_state = function() end,
              set_arguments = function(_, args) HTTPResponse = args end,
              finalize_context = function() end,
          }, { __tostring = function() end })
      end
      HTTPClient:b_connect()
  end
  HTTPClient.b_finalize_request = HTTPClient._finalize_request
  HTTPClient._finalize_request = function()
      HTTPClient:b_finalize_request()
      callback(HTTPResponse[1])
  end
  HTTPClient:fetch(url, kwargs)
  return true
end