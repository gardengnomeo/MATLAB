% Lucas Simpson
% Signals & Systems project 1

function msg = decode(sig_received,fs,varargin)

% check if there is a default pulse or not
if (isempty(varargin))
    pulse = ones(1, (0.5 * fs) + 1);
else
    pulse = varargin{1};
end

% convolute the recieved signal with the pulse to remove noise

flipped_pulse = fliplr(pulse);
noise_filtered = conv(sig_received, flipped_pulse, 'full');

% convert noiseless signal to binary
step = length(pulse);
binary_length = floor( length(noise_filtered) / step);

binary_string = repmat('0', 1, binary_length);

for i = 1:binary_length
    if noise_filtered(i*step) > 0
        binary_string(i) = '1';
    end
end

% open the ascii file and put values into a map for easy conversion
ascii_code = fopen('ascii.code', 'r');
ascii_map = containers.Map('KeyType', 'char', 'ValueType', 'char');

while ~feof(ascii_code)
    line = fgetl(ascii_code);
    ascii_map(line(4:11)) = line(1);
end
fclose(ascii_code);

% convert binary to a message

msg_length = floor( length(binary_string) / 8);

msg = repmat(' ', 1, msg_length);

for i = 1:8:length(binary_string)
    byte = binary_string(i:i+7);
    n = (i+7)/8;
    if isKey(ascii_map, byte)
        msg(n) = ascii_map(byte);
    else
        msg(n) = 'z'; % there is no z in ascii.code so using it as default
    end
end

end