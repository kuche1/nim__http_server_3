import tables
import os

import nhs/nhs

on_connection(proc(u:var U)=
    echo "Conenction from: ", u.ip

    if u.recive_header(): return
    #echo "Meth: ", u.meth
    echo "Url: ", u.url
    #echo "Proto: ", u.proto
    #echo "Head: ", u.head

    if u.recive_body(): return
    #echo "Body: ", u.body

    #if u.send_download("response.txt", "downloaded file.txt"): return
    #echo "Response sent"
    
    #if u.send_html("response.html"): return
    #echo "HTML response sent"

    let dir= u.url[1 .. ^1]
    if file_exists(dir):
        if u.send_download( dir, dir ): return
    else:
        if u.send_str("File not found: " & dir): return
):
    discard stdin.readline()

