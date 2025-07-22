function [tidesout, tide_fit] = tidemod_kl_plot(coefs,t,ju,tanthter,freqs,lat)

% times should be in datenum format (days)
times0= t - median(t);

ltype='nodal';
ctime = median(t);
[v,u,f] = t_vuf(ltype,ctime,ju+1,lat);
v = v.*360;
u = u.*360;

tidesout = zeros( numel(t), 1 );
tide_fit = zeros( numel(t), 1 );
for ii = 1:numel(freqs)
    tidesout = tidesout + 2*pi*freqs(ii)*f(ii).*( coefs(ii*2-1) * sind(360*freqs(ii).*times0.*24 + u(ii)+v(ii)) ...
        - coefs(ii*2) * cosd( 360*freqs(ii).*times0.*24 + u(ii) +v (ii) ) );

    tide_fit = tide_fit + f(ii).*( coefs(ii*2-1) * cosd(360*freqs(ii).*times0.*24 + u(ii)+v(ii)) ...
        +coefs(ii*2) * sind( 360*freqs(ii).*times0.*24 + u(ii) +v (ii) ) );
end

tidesout = tidesout.*tanthter;

end
