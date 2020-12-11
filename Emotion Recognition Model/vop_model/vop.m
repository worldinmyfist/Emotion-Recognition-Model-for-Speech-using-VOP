function vop_count_file = vop(file)
    [y , fs] = audioread(file);
    windowlength = 20*fs/1000; 
    overlap = 10*fs/1000; 
    
    lp_residual = zeros(1,length(y));
    estimated_signal = zeros(1,length(y));
    envelope = zeros(1,length(y));
    lpf_preemphasized_inp = zeros(1,length(y));
    [lpf_preemphasized_inp(1:overlap), lp_residual(1:overlap), estimated_signal(1:overlap), envelope(1:overlap)] = segmental_analysis(y(1:overlap),fs);
    
  
    for i = 1:overlap:(length(y)-windowlength)
        [inp_fin_temp, lp_residual_temp, est_fin_temp, envelope_fin_temp] = segmental_analysis(y(i:windowlength+i-1),fs);
        lpf_preemphasized_inp(i+overlap-1:i+windowlength-1) = inp_fin_temp(overlap:length(inp_fin_temp));
        lp_residual(i+overlap-1:i+windowlength-1) = lp_residual_temp(overlap:length(lp_residual_temp));
        estimated_signal(i+overlap-1:i+windowlength-1) = est_fin_temp(overlap:length(est_fin_temp));
        envelope(i+overlap-1:i+windowlength-1) = envelope_fin_temp(overlap:length(envelope_fin_temp));
    end
    
    %Modulated Gaussian window
    temp = (-399:400);
    mod_gaussian = zeros(1,length(temp));
    for i = 1:800
        mod_gaussian(i) = (sin(0.0114*(temp(i)-15))./sqrt(2*pi*10000)).*exp(-(temp(i)*temp(i))/20000);
    end
    
    %Convoluting envelope and negative of modulated gaussian window
    output_fin = conv(envelope,-mod_gaussian,'same');
    
    %Detecting VOP
    detected_vop_points = [];
    
    if output_fin(1) > output_fin(2) && output_fin(1) > 0
        detected_vop_points = [detected_vop_points,1];
    end
    
    for i = 2:(length(output_fin)-1)
        if output_fin(i)>output_fin(i-1) && output_fin(i) > output_fin(i+1) && output_fin(i) > 0
            detected_vop_points = [detected_vop_points,i];
        end
    end
    
    if output_fin(length(output_fin)) > output_fin(length(output_fin)-1) && output_fin(length(output_fin)) > 0
        detected_vop_points = [detected_vop_points,length(output_fin)];
    end
    
    %Detecting local minimas between any 2 detected VOP points
    detected_minima_amplitude = [];
    
    min_temp = output_fin(1);
    for i = 1:detected_vop_points(1)
        if output_fin(i) < min_temp
            min_temp = output_fin(i);
        end
    end
    
    detected_minima_amplitude = [detected_minima_amplitude,min_temp];
    
    for i = 1:(length(detected_vop_points)-1)
        min_temp = output_fin(detected_vop_points(i));
        for j = detected_vop_points(i):detected_vop_points(i+1)
            if output_fin(j) < min_temp
                min_temp = output_fin(j);
            end
        end
        detected_minima_amplitude = [detected_minima_amplitude,min_temp];
    end
    
    min_temp = output_fin(detected_vop_points(length(detected_vop_points)));
    for i = detected_vop_points(length(detected_vop_points)):length(output_fin)
        if output_fin(i) < min_temp
            min_temp = output_fin(i);
        end
    end
        
    detected_minima_amplitude = [detected_minima_amplitude,min_temp];
    
    %Amplitude difference between neighbouring minimas and VOP points
    Amplitude_difference = [];    
    for i = 1:length(detected_vop_points)
        Amplitude_difference = [Amplitude_difference,(output_fin(detected_vop_points(i))-detected_minima_amplitude(i))];
        Amplitude_difference = [Amplitude_difference,(output_fin(detected_vop_points(i))-detected_minima_amplitude(i+1))];
    end
    
    detected_maxima_amplitude = [];
    
    for i = 1:length(detected_vop_points)
        detected_maxima_amplitude = [detected_maxima_amplitude,output_fin(detected_vop_points(i))];
    end
    
    Amplitude_difference_sorted = sort(Amplitude_difference);
    diff_temp = 0;
    spurious_threshold = Amplitude_difference_sorted(1);
    
    for i = 1:(length(Amplitude_difference_sorted)-1)
        if Amplitude_difference_sorted(i+1)-Amplitude_difference_sorted(i) > diff_temp
            diff_temp = Amplitude_difference_sorted(i+1)-Amplitude_difference_sorted(i);
            spurious_threshold = Amplitude_difference_sorted(i);
        end
    end
    
    %Calculating mean to get threshold to remove spurious peaks
    mean_diff = mean(Amplitude_difference);
    param_used = spurious_threshold;
    
    %Hypothesized VOP events
    vop = [];

    for i = 1:length(detected_vop_points)
        if (output_fin(detected_vop_points(i))-detected_minima_amplitude(i)) >= mean_diff && (output_fin(detected_vop_points(i))-detected_minima_amplitude(i+1)) >= mean_diff
            vop = [vop,detected_vop_points(i)];
        end
    end
    
    %Creating txt files with VOP array
    cd ./vop_txt/ ;
    filename = sprintf('%s.txt',file);
    csvwrite(filename,vop');
    cd ../ ;
    
    %Returning number of VOPs for this file
    vop_count_file = length(vop);
     
%     plot(lpf_preemphasized_inp);
%     title('Pre-emphasized Low pass filtered input');
%     figure();
%     plot(lp_residual);
%     title('LP Residual');
%     figure();
%     plot(envelope);
%     title('Hilbert envelope');
%     figure();
%     plot(output_fin);
%     title('Output after convolution with modulated gaussian window');
   
%     figure();
%     subplot(211);
%     title('Detected VOP');
%     hold on 
%     plot(0,0);
%     plot(length(y),0);
%     for i = 1:length(detected_vop_points)
%         stem(detected_vop_points(i),output_fin(detected_vop_points(i)),'color','red');
%     end
%     hold off
%     subplot(212);
%     title('Hypothesized VOP');
%     hold on
%     plot(0,0);
%     plot(length(y),0);
%     for i = 1:length(vop)
%         stem(vop(i),output_fin(vop(i)),'color','red');
%     end
%     hold off
%     
%     figure();
%     subplot(211);
%     plot(y);
%     title('Pre-emphasized Low pass filtered input');
%     subplot(212);
%     title('Hypothesized VOP');
%     hold on 
%     plot(length(y),0);
%     plot(0,2);
%     for i = 1:length(vop)
%         stem(vop(i),1,'color','red');
%     end
%     hold off

end