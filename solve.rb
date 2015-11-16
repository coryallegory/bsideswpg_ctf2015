require 'base64'
require 'zlib'


file = File.open('coindata.txt', 'rb')
coin_data = file.read

decoded = Base64.decode64(coin_data)

File.open('decoded', 'w') { |file| file.write(decoded) }

decompressed = Zlib::Inflate.inflate(decoded)    

File.open('decompressed.mp2', 'w') { |file| file.write(decompressed) }

bits = decompressed.each_byte.map { |b|
  puts b.to_s(2) << " " << b.to_s(2).rjust(8,'0')
  b.to_s(2).rjust(8,'0')
}.join

File.open('bits.txt', 'w') { |file| file.write(bits) }

puts bits.length

bits.scan(/.{42}/).map { |b| puts b}

qrcode = "<html><head><style>div { width:10px; height:10px; display:inline-block } .black { background-color:black } </style></head><body>"
bits.scan(/.{42}/).map { |b|
  qrcode << b.gsub("1", "<div class=\"black\"></div>").gsub("0", "<div></div>")
  qrcode << "<br />"
}
qrcode << "</body></html>"

File.open('qrcode.html', 'w') { |file| file.write(qrcode) }
