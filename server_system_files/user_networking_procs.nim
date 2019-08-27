
import strutils
from times import cpu_time
from net import recv, TimeoutError, send
from cgi import decode_url


proc recive_header*(u:var U):bool=
    let end_at= int(cpu_time()*1000) + u.time_to_recive_header
    var recived:string
    while true:
        let remains= end_at - int(cpu_time()*1000)
        if remains <= 0:
            return true
        
        var bit:string
        try:
            if u.con.recv(bit, 1, remains) == 0:
                return true
        except TimeoutError:
            return true
        recived.add bit
        
        if recived.ends_with("\r\L"):
            recived= recived[0 .. ^3]
            break
        if len(recived) >= (u.header_maxlen+2):
            return true
            
    if recived.count(' ') != 2:
        return true
    
    var meth:string
    var url:string
    var proto:string
    (meth, url, proto)= recived.split(' ')
    u.meth= decode_url(meth)
    u.proto= decode_url(proto)
    
    let question_mark_ind= url.find('?')
    if question_mark_ind == -1:
        u.url= url
    else:
        u.url= url[0 ..< question_mark_ind]
        for item in url[(question_mark_ind+1) .. ^1].split('&'):
            let ind= item.find('=')
            if ind == -1:
                u.head[ decode_url(item) ]= ""
            else:
                u.head[ decode_url(item[0 ..< ind]) ]= decode_url(item[(ind+1)..^1])


proc recive_body*(u:var U):bool=
    let end_at= int(cpu_time()*1000) + u.time_to_recive_body
    var recived:string
    while true:
        let remains= end_at - int(cpu_time()*1000)
        if remains <= 0:
            echo "Time left"
            return true
        
        var bit:string
        try:
            if u.con.recv(bit, 1, remains) == 0:
                echo "disconnected by user"
                return true
        except TimeoutError:
            echo "Time left 2"
            return true
        recived.add bit
        
        if recived.ends_with("\r\L\r\L"):
            recived= recived[0 .. ^5]
            break
        if len(recived) >= (u.body_maxlen+4):
            echo "Too long"
            return true
            
    for item in recived.split("\r\L"):
        let ind= item.find(": ")
        if ind == -1:
            u.body[ item ]= ""
        else:
            u.body[ item[0 ..< ind]]= item[(ind+2) .. ^1]


# raw send
    
proc raw_send_str(u:var U, to_send:string):bool=
    try:
        var bit= new_string(1)
        if u.con.recv(bit, 1, 1)==0:
            return true
    except TimeoutError:
        discard
        
    while true:
        try:
            u.con.send(to_send)
        except OSError:
            continue
        break
    
proc raw_send_file(u:var U, dir:string):bool=
    let buffer= u.send_file_chunk
    var to_send= new_string(buffer)
    let f= open(dir)
    while true:
        let red_amount= f.read_chars(to_send, 0, buffer)
        echo "SENT: ", red_amount
        if red_amount == 0:
            close(f)
            return
        if red_amount < buffer:
            close(f)
            return u.raw_send_str(to_send[0 ..< red_amount])
        if u.raw_send_str(to_send):
            close(f)
            return true
    
# http header

proc http_content_disposition(u:var U, info:string)=
    u.header.add "Content-disposition: " & info & '\n'

proc http_content_type(u:var U, info:string)=
    u.header.add "Content-Type: " & info & '\n'
    
proc http_end(u:var U):bool=
    u.header.add "\n"
    result= u.raw_send_str( u.header )
    u.header= ""
    
proc http_ok(u:var U)=
    u.header.add "HTTP/1.X 200 OK\n"

#  actual send

proc send_download*(u:var U, dir:string, name:string):bool=
    u.http_ok()
    u.http_content_disposition("attachment; filename=\"" & name & '\"')
    if u.http_end(): return true
    if u.raw_send_file(dir): return true
    
proc send_file*(u:var U, dir:string):bool=
    u.http_ok()
    if u.http_end(): return true
    if u.raw_send_file(dir): return true

proc send_html*(u:var U, dir:string):bool=
    u.http_ok()
    u.http_content_type("text/html")
    if u.http_end(): return true
    if u.raw_send_file(dir): return true
    
proc send_str*(u:var U, to_send:string):bool=
    u.http_ok()
    if u.http_end(): return true
    if u.raw_send_str(to_send): return true
    
