
import tables

type U* =object
    con:Socket
    header:string
    uploaded_bytes:int64
    upload_started_at:float
    
    body:Table[string,string]
    head:Table[string,string]
    ip:string
    meth:string
    proto:string
    url:string
    
    body_maxlen*:int
    client_download_headstart*:float
    cant_send_delay*:int
    header_maxlen*:int
    min_download_speed*:int
    send_file_chunk*:int
    time_to_recive_body*:float
    time_to_recive_header*:float
    
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
    result.client_download_headstart= 5
    result.cant_send_delay= 50
    result.header_maxlen= 100
    result.min_download_speed= 1024
    result.send_file_chunk= 2048
    result.time_to_recive_body= 10.0
    result.time_to_recive_header= 2.0
    
    dealloc( s )



include user_networking_procs
