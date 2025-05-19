% Lucas Simpson
% Signals & Systems project 1

% create message and convert it to a binary signal
message = '#TurnMySwag0n :)';

binary_message = charToBinary(message);

% create the different pulse types
fs = 100;
pulse_duration = 0.5;
num_steps = pulse_duration * fs + 1;

square_pulse = ones(1, num_steps);
tringle_pulse  = linspace(0,1, num_steps);

freq = 2 / pulse_duration;
t = linspace(0,pulse_duration,fs);
sine_pulse = sin(freq * pi * t);


unit_pulse = zeros(1,num_steps);
for i = 1:2:num_steps
    unit_pulse(i) = 1;  
end


% create the signal and then add the noise for square pulse
signal = binaryToSignal(binary_message, square_pulse);
noisy_signal = addNoise(signal, 2.9);


% plot the signal and the noisy signal using square pulse 
t = (0:length(signal)-1) / fs;

figure;
hold on;
plot(t,noisy_signal, 'r');
plot(t, signal, 'k', 'LineWidth', 1);
title('Signal and Noisy Signal');
xlabel('Time');
ylabel('Amplitude');
legend('signal with noise', 'signal');
hold off;

% decode the message to see if it is working
msg = decode(noisy_signal, fs, square_pulse);
disp(msg);



% create the signal and then add the noise using triangle pulse 
signal = binaryToSignal(binary_message, tringle_pulse);
noisy_signal = addNoise(signal, 1.5);

% plot the signal and the noisy signal using triangle pulse 
t = (0:length(signal)-1) / fs;

figure;
hold on;
plot(t,noisy_signal, 'r');
plot(t, signal, 'k', 'LineWidth', 1);
title('Signal and Noisy Signal');
xlabel('Time');
ylabel('Amplitude');
legend('signal with noise', 'signal');
hold off;

% decode the message to see if it is working
msg = decode(noisy_signal, fs, tringle_pulse);
disp(msg);



% create the signal and then add the noise using triangle pulse 
signal = binaryToSignal(binary_message, sine_pulse);
noisy_signal = addNoise(signal, 2.5);

% plot the signal and the noisy signal using triangle pulse 
t = (0:length(signal)-1) / fs;

figure;
hold on;
plot(t,noisy_signal, 'r');
plot(t, signal, 'k', 'LineWidth', 1);
title('Signal and Noisy Signal');
xlabel('Time');
ylabel('Amplitude');
legend('signal with noise', 'signal');
hold off;

% decode the message to see if it is working
msg = decode(noisy_signal, fs, sine_pulse);
disp(msg);





% create the signal and then add the noise using triangle pulse 
signal = binaryToSignal(binary_message, unit_pulse);
noisy_signal = addNoise(signal, 2);

% plot the signal and the noisy signal using triangle pulse 
t = (0:length(signal)-1) / fs;

figure;
hold on;
plot(t,noisy_signal, 'r');
plot(t, signal, 'k', 'LineWidth', 1);
title('Signal and Noisy Signal');
xlabel('Time');
ylabel('Amplitude');
legend('signal with noise', 'signal');
hold off;

% decode the message to see if it is working
msg = decode(noisy_signal, fs, unit_pulse);
disp(msg);






% helper function to convert a character string to binary
function msg = charToBinary(char_string)

ascii_code = fopen('ascii.code', 'r');
ascii_map = containers.Map('KeyType', 'char', 'ValueType', 'char');

while ~feof(ascii_code)
    line = fgetl(ascii_code);
    ascii_map(line(1)) = line(4:11);
end
fclose(ascii_code);

msg_length = length(char_string) * 8;

msg = repmat(' ', 1, msg_length);

for i = 1:length(char_string)
    n = 8 * i - 7;
    msg(n:n+7)= ascii_map(char_string(i));
end

end



%helper function to convert the binary to a signal
function signal = binaryToSignal(binary_string, pulse)

binary_length = length(binary_string);
pulse_length = length(pulse);
signal_length = pulse_length * binary_length;
signal = zeros(1, signal_length);

for i = 1:binary_length
    start_idx = (i - 1) * pulse_length + 1;
    end_idx = start_idx + pulse_length - 1;
    
    if binary_string(i) == '1'
        signal(start_idx:end_idx) = pulse;
    else
        signal(start_idx:end_idx) = -pulse;
    end
end

end


% helper function that adds noise depending on noise level
function noisy_signal = addNoise(signal, a)
    noisy_signal = signal + a * randn(1, length(signal));
end



