
from net import Socket, new_socket

# import settings_handler


type S = object
    running:bool
    sock:Socket

    body_maxlen:int
    cant_send_delay:int
    forcefully_take_port:bool
    header_maxlen:int
    listen:int32
    no_new_connection_delay:int
    port:int
    send_file_chunk:int
    time_to_recive_body:int
    time_to_recive_header:int
    


proc new_server*:S=
    result= S()
    result.running= true
    result.sock= new_socket()
    
    result.body_maxlen= 2048
    result.cant_send_delay= 50
    result.forcefully_take_port= true
    result.header_maxlen= 100
    result.listen= 5
    result.no_new_connection_delay= 200
    result.port= 80
    result.send_file_chunk= 2048
    result.time_to_recive_body= 10_000
    result.time_to_recive_header= 2_000



include user

include start_server_proc

