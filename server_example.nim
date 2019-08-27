
import tables
import os

import "server_system_files/nice_web_server"



var s= new_server()

s.forcefully_take_port= true
s.listen= 5
s.no_new_connection_delay= 300
s.port= 80
s.ssl= false







proc on_connection(u:var U)=
    echo "Conenction from: ", u.ip

    if u.recive_header(): return
    echo "Meth: ", u.meth
    echo "Url: ", u.url
    echo "Proto: ", u.proto
    echo "Head: ", u.head

    if u.recive_body(): return
    echo "Body: ", u.body

    #if u.send_download("response.txt", "downloaded file.txt"): return
    #echo "Response sent"
    
    #if u.send_html("response.html"): return
    #echo "HTML response sent"

    let dir= u.url[1 .. ^1]
    if file_exists(dir):
        if u.send_download( dir, dir ): return
    
    else:
        if u.send_str("File not found: " & dir): return



s.start_server( on_connection )

discard stdin.readline()
s.stop_server()
