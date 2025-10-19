%https://blogs.mathworks.com/steve/2009/02/18/image-overlay-using-transparency/?s_tid=srchtitle
figure('renderer','opengl')
ha1 = axes('parent',gcf);
ha2 = axes('parent',gcf);
set(ha2,'color','none');
hi1 = imshow(red,'parent',ha1);
hi2 = imshow(green,'parent',ha2);
tmp1 = imgs(:,:,1)*5/7347;
tmp1(tmp1>1)=1;
tmp2 = imgs(:,:,end)*5/7347;
tmp2(tmp2>1)=1;
set(hi1,'alphadata',tmp1);
set(hi2,'alphadata',tmp2);
