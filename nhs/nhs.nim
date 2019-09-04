
from net import new_socket, accept_addr, close, set_sock_opt, OptReuseAddr, bind_addr, Port, listen, get_fd
from locks import Lock, init_lock, deinit_lock, acquire, release
from nativesockets import set_blocking
from os import sleep
from threadpool import spawn, sync



var running= true
var sock= new_socket()
var threads:int
var threads_lock:Lock
init_lock threads_lock

include user

var
    forcefully_take_port* =true
    listen*:int32 =5
    no_new_connection_delay* =200
    port* =80

proc handle_new_connections(s:ptr Socket, on_connection:proc(_:var U))=
    var con:Socket
    var ip:string
    
    while true:
        try:
            s[].accept_addr(con, ip) #GC unsafe
            discard
        except OSError:
            sleep no_new_connection_delay
            if running:
                continue
            else:
                echo "SHUTTING DOWN"
                dealloc s
                return
        break
        
    acquire threads_lock
    inc threads
    echo "Threads: ", threads
    release threads_lock
    
    spawn handle_new_connections(s, on_connection)
    
    var u= new_user(con, ip)
    on_connection u
    close con
    echo "DISCONNECTED"
    
    acquire threads_lock
    dec threads
    echo "Threads: ", threads
    release threads_lock
    

proc start_server(on_connection:proc(_:var U) )=
    if forcefully_take_port:
        sock.set_sock_opt(OptReuseAddr, true)

    try:
        sock.bind_addr Port(port)
    except OSError:
        echo getCurrentExceptionMsg()
        quit()
    echo "Bound to port: ", port
    
    sock.listen listen
    sock.get_fd().set_blocking false
    
    spawn handle_new_connections(sock.addr, on_connection)
    
proc stop_server =
    running= false
    sync()
    deinit_lock threads_lock
    close sock

template on_connection*(on_con:proc(_:var U), exit_cond:typed)=
    start_server on_con
    exit_cond
    stop_server()
