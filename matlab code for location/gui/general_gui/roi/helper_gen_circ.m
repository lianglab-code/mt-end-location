% circle generation
function circ = helper_gen_circ(c,r)
num_p = 30;
theta = linspace(0,pi*2-pi*2/num_p,num_p);
circ = zeros(2,num_p);
circ = repmat(c,1,num_p) + r*[cos(theta);sin(theta)];
end