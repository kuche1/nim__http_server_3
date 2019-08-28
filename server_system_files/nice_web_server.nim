
from net import Socket, new_socket

# import settings_handler


type S = object
    running:bool
    sock:Socket

    cant_send_delay*:int
    forcefully_take_port*:bool
    listen*:int32
    no_new_connection_delay*:int
    port*:int
    


proc new_server*:S=
    result= S()
    result.running= true
    result.sock= new_socket()
    
    result.cant_send_delay= 50
    result.forcefully_take_port= true
    result.listen= 5
    result.no_new_connection_delay= 200
    result.port= 80



include user

include start_server_proc

