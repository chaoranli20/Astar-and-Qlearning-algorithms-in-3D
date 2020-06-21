function n_index = node_index(OPEN,xval,yval,zval)

i=1;
while(OPEN(i,2) ~= xval || OPEN(i,3) ~= yval || OPEN(i,4) ~= zval )
    i=i+1;
end
n_index=i;
end