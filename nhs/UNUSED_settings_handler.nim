
from os import file_exists
from strutils import parse_float, parse_int

let dsd= "server_system_files/default_settings/"
let sd=  "server_system_files/settings/"




# READS

proc read(dir:string):string=
    var f:File
    if open(f, dir):
        try:
            result= read_line(f)
        except EOFError:
            echo "Setting file empty: ", dir
            echo "You can find a full one in: ", dsd
            close(f)
            quit(1)
        close(f)
    else:
        echo "Missing setting file: ",dir
        echo "You can find a new one in: ", dsd
        quit(1)

proc r_bool*(name:string):bool=
    let dir= sd & name & ".bool"
    case read(dir)
    of "yes": return true
    of "no": return false
    
proc r_float*(name:string):float=
    let dir= sd & name & ".float"
    try:
        result= parse_float( read(dir) )
    except ValueError:
        echo "Bad float value in settrings file: ", dir
        echo "You can find a replacement in: ", dsd
        quit(1)

proc r_int*(name:string):int=
    let dir= sd & name & ".int"
    try:
        result= parse_int( read(dir) )
    except ValueError:
        echo "Bad integer value in setting file: ", dir
        echo "You can find a replacement in: ", dsd
        quit(1)
        
proc r_int32*(name:string):int32=
    let dir= sd & name & ".int"
    try:
        result= int32( parse_int( read(dir) ) )
    except ValueError:
        echo "Bad integer value in setting file: ", dir
        echo "You can find a replacement in: ", dsd
        quit(1)

proc r_str*(name:string):string=
    let dir= sd & name & ".str"
    result= read(dir)
    

# WRITES

proc w_bool*(name:string,new:bool)=
    let dir= sd & name & ".bool"
    if new:
        writefile(dir, "yes")
    else:
        writefile(dir, "no")

proc w_float*(name:string,new:float)=
    let dir= sd & name & ".float"
    writefile(dir, $ new)

proc w_int*(name:string,new:int)=
    let dir= sd & name & ".int"
    writefile(dir, $ new)
    
proc w_int32*(name:string,new:int)=
    let dir= sd & name & ".int"
    writefile(dir, $ new)

proc w_str*(name:string,new:string)=
    let dir= sd & name & ".str"
    writefile(dir, new)
    
