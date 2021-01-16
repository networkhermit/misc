:input
$!{N;binput}
G

# insert horizontal wall to disable wrapping
s/^[^\n]*\n/&&/
:sub
s/^(#*)[^#\n]([^\n]*\n)/\1#\2/
tsub

:bfs
# insert EOF marker
s/.*/&@/

:rotate1

# interleave first line with markers
s/^([^\n]*\n)([^\n]*\n)/\2\1\2/
:sub1
s/^([^\n@]*)@/\1/
s/^(=*)[^=\n]([^\n]*\n)/\1=\2/
tsub1
s/^(=*)\n/\1=/;s/^/=/
:interleave1
s/=((=[^=])+)/\1=/
tinterleave1
s/=//

s/^([Eudlr].*=) ([^=]*)$/\1U\2/
s/^ (.*=[Eudlr][^=]*)$/D\1/
s/^([Eudlr].*=)S([^=]*)$/\1^\2/
s/^S(.*=[Eudlr][^=]*)$/v\1/

s/=//g
# rotate queue
s/([#\n]+|.)(.*)/\2\1/

# keep rotating until we hit EOF
/^@/!brotate1
s/^@//

s/ ([Eudlr])/R\1/g
s/([Eudlr]) /\1L/g
s/S([Eudlr])/>\1/g
s/([Eudlr])S/\1</g
p

# mark as visited
y/UDLR/udlr/

/S/bbfs
p

:trace
# insert EOF marker
s/.*/&@/

:rotate2

# interleave first line with markers
s/^([^\n]*\n)([^\n]*\n)/\2\1\2/
:sub2
s/^([^\n@]*)@/\1/
s/^(=*)[^=\n]([^\n]*\n)/\1=\2/
tsub2
s/^(=*)\n/\1=/;s/^/=/
:interleave2
s/=((=[^=])+)/\1=/
tinterleave2
s/=//

s/^(v.*=)u([^=]*)$/\1^\2/
s/^(v.*=)d([^=]*)$/\1v\2/
s/^(v.*=)l([^=]*)$/\1<\2/
s/^(v.*=)r([^=]*)$/\1>\2/

s/^u(.*=\^[^=]*)$/^\1/
s/^d(.*=\^[^=]*)$/v\1/
s/^l(.*=\^[^=]*)$/<\1/
s/^r(.*=\^[^=]*)$/>\1/

# exit when end is reached
/E<|>E|^v(.*=E[^=]*)$|^E(.*=\^[^=]*)$/bbreak

s/=//g
# rotate queue
s/([#\n]+|.)(.*)/\2\1/

/^@/!brotate2
s/^@//

s/>u/>^/
s/>d/>v/
s/>l/></
s/>r/>>/

s/u</^</
s/d</v</
s/l</<</
s/r</></
p

btrace
:break

s/=//g
# rotate back
s/^([^@]*)@(.*)$/\2\1/
p

# delete wall
s/^#*\n//

# delete unused paths
s/[udlr]/ /g

# optional: colorize path
s/[v^<>]/\x1B[31m&\x1B[0m/g
s/E/\x1B[32mE\x1B[0m/g
s/E/@/

q
