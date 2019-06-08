program test2;
var a, b, i: integer;
begin
    a := 0;
    b := 1;
    i := 1;
    while( i <= 10 ) do
      begin
        a := a + i;
        b := b * i;
	i := i + 1
      end;
    write( a );
    write( b )
end.
