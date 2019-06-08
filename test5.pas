program test5;

var a, b, i, x: integer;
    t, f: Boolean;
    A: array[1..10] of integer;

procedure hello;
begin
    write( "Input ?" )
end;

begin
    a := 0;
    b := 1;
    i := 1;
    t := true;
    f := false;
    hello;
    read( x );
    if ( x > 10 ) then x := 10
    else if ( x < 1 ) then x := 1;
    while( i <= x ) do
      begin
        a := a + i;
        b := b * i;
        A[i] := a + b;
        write( A[i] );
	i := i + 1
      end;
    write( a, b );
end.
