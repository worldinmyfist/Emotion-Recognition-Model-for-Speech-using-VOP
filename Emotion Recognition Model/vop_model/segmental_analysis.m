function [lpf_preemphasized,lp_residual_seg,est_inp,envelope] = segmental_analysis(inp,fs)
   
    %Pre-emphasis
    B = [1 -0.95];
    preemphasized = filter(B,1,inp);
    
    %Low-pass filtering
    lpf_preemphasized = lowpass(preemphasized,2500,fs);
    
    %Order of lpc
    p = 8; 
   
    %LPC
    [a,~] = lpc(lpf_preemphasized,p);
    est_inp = filter([0 -a(2:end)],1,lpf_preemphasized);
   
    %LP Residual
    lp_residual_seg = inp - est_inp; 
    
    %Calculating Hilbert envelope
    hilbert_lp = hilbert(lp_residual_seg);     
    x = lp_residual_seg + (1i)*(hilbert_lp);    
    envelope = abs(x);
end

