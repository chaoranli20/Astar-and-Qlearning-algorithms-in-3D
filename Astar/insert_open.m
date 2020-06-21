function new_row = insert_open(xval,yval,zval,parent_xval,parent_yval,parent_zval,gn,hn,fn)
% 返回open_list结构的一行数组
new_row=[1,10];
new_row(1,1)=1;
new_row(1,2)=xval;
new_row(1,3)=yval;
new_row(1,4)=zval;
new_row(1,5)=parent_xval;
new_row(1,6)=parent_yval;
new_row(1,7)=parent_zval;
new_row(1,8)=gn;
new_row(1,9)=hn;
new_row(1,10)=fn;
end