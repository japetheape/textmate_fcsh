require 'em-websocket'

class WebsocketServer
  
  def initialize
    @connected = []
    a = Thread.start do 
      EventMachine::WebSocket.start(:host => "0.0.0.0", :port => 8080) do |ws|
        ws.onopen    { 
          
          @connected << ws 
          
        }
        ws.onmessage { |msg| 
           }
        ws.onclose   { @connected.delete(ws) }
      end
    end
  end
  
  
  def send(mess)
    @connected.each do |c|
      c.send mess
    end
  end
  
end