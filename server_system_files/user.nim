
import tables

type U* =object
    con:Socket
    header:string
    
    body:Table[string,string]
    head:Table[string,string]
    ip:string
    meth:string
    proto:string
    url:string
    
    body_maxlen:int
    cant_send_delay:int
    header_maxlen:int
    send_file_chunk:int
    time_to_recive_body:float
    time_to_recive_header:float
    
proc body*(u:var U):Table[string,string]= u.body
proc head*(u:var U):Table[string,string]= u.head
proc ip*(u:var U):string= u.ip
proc meth*(u:var U):string= u.meth
proc proto*(u:var U):string= u.proto
proc url*(u:var U):string= u.url

    
proc new_user(con:Socket, ip:string, s:ptr S):U=
    result= U()
    result.con= con
    
    result.ip= ip
    
    result.body_maxlen= 2048
    result.header_maxlen= 100
    result.send_file_chunk= 2048
    result.time_to_recive_body= 10.0
    result.time_to_recive_header= 2.0
    
    dealloc( s )



include user_networking_procs
