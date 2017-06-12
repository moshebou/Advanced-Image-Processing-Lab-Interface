function mbint(a)
%MBINT   Must be integer.
%   The statement
%
%       mbint(x)
%
%   asserts that, at that point in the computation, the variable x 
%   has components which can be declared type "int" in the resulting
%   C program.  If this assertion is false, an error occurs; if this
%   assertion is true, the computation proceeds.
%
%   See also MBINTSCALAR, MBINTVECTOR, MBREAL, MBREALSCALAR,
%            MBREALVECTOR, MBSCALAR, MBVECTOR.

% $Revision: 1.5 $  $Date: 1997/11/24 15:26:44 $
% Copyright 1995 - 1998 The MathWorks, Inc.  All Rights Reserved.


if any(any(a ~= fix(a))) | any(any(imag(a))) 
   error( 'argument to mbint must be integer' );
end
