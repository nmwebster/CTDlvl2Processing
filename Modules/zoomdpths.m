function zoomdpths
global D  wx l1 l2


Dorig = D;

subplot(1,3,1)
disp('Click twice on plot to get depth-to-zoom endpoints.');  disp(' ');

a = ginput(2);


y(1) = min(wx(find(abs(D(wx,2)-a(1,2)) == min(abs(D(wx,2)-a(1,2))))));
dpth(1) = D(y(1),2);
y(2) = max(wx(find(abs(D(wx,2)-a(2,2)) == min(abs(D(wx,2)-a(2,2))))));
dpth(2) = D(y(2),2);

X = [dpth' y'];
X = sortrows(X,1);

if X(2,1)-X(1,1) < 2,
	disp('Points must be separated by at least 1 m.'); disp(' ');
else
	l1 = X(1,1);
	l2 = X(2,1);
	plotv
end
