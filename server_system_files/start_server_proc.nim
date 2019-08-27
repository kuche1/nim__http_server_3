
from net import set_sock_opt, OptReuseAddr, bind_addr, Port, listen, get_fd, accept_addr, close
from nativesockets import set_blocking
from os import sleep
from threadpool import nil


proc handle_new_connections(s:ptr S, on_connection:proc(u:var U) )=
    var con:Socket
    var ip:string
    
    while true:
        try:
            s.sock.accept_addr(con, ip)
        except OSError:
            if s.running:
                sleep( s.no_new_connection_delay )
                continue
            else:
                echo "SHUTTING DOWN"
                close( s.sock )
                dealloc( s )
                return
        break
    
    threadpool.spawn handle_new_connections(s, on_connection)
    
    var u= new_user(con, ip, s)
    on_connection(u)
    close( con )
    echo "DISCONNECTED"
    

proc start_server*(s:var S, on_connection:proc(u:var U) )=
    echo "Note: SSL doesnt work yet"

    if s.forcefully_take_port:
        s.sock.set_sock_opt(OptReuseAddr, true)

    try:
        s.sock.bind_addr( Port(s.port) )
    except OSError:
        echo getCurrentExceptionMsg()
        quit(1)
    echo "Bound to port: ", s.port
    
    s.sock.listen( s.listen )
    s.sock.get_fd().set_blocking(false)
    
    threadpool.spawn handle_new_connections(s.addr, on_connection)

proc request_server_to_stop*(s:var S)=
    s.running= false

proc wait_for_server_to_stop*()=
    threadpool.sync()
    
proc stop_server*(s:var S)=
    request_server_to_stop(s)
    wait_for_server_to_stop()
