isable(A,B,C,X,Y):-
    S0 is ((X**2)+(Y**2)),
    S1 is ((A**2)+(B**2)),
    S2 is ((B**2)+(C**2)),
    S3 is ((A**2)+(C**2)),
    (S1 =< S0) | (S2 =< S0) | (S3 =< S0),
    nl.
