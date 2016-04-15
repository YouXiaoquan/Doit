--[[print('')
print('-------WiFiMCU Demo--------')
print('wechat demo fo doit cloud')]]

function write_frame(d)
	local f_data =d
	local temp = bit.lshift(0x01,31)
	for i=1,32 do
		gpio.write(pinClk,gpio.LOW)
		if bit.band(f_data,temp) ==0 then
			gpio.write(pinDin,gpio.LOW)
		else
			gpio.write(pinDin,gpio.HIGH)
		end
		gpio.write(pinClk,gpio.HIGH)
		f_data = bit.lshift(f_data,1)
	end
	f_data=nil
	collectgarbage()
end

function write_data(b,g,r)
	local check_byte = 0xc0
	local send_data = 0
	check_byte =bit.bor(check_byte,bit.band(bit.rshift(bit.bnot(b),2),0x30))
	check_byte =bit.bor(check_byte,bit.band(bit.rshift(bit.bnot(g),4),0x0C))
	check_byte =bit.bor(check_byte,bit.band(bit.rshift(bit.bnot(r),6),0x03))

	send_data = bit.bor(send_data,bit.lshift(check_byte,24))
	send_data = bit.bor(send_data,bit.lshift(b,16))
	send_data = bit.bor(send_data,bit.lshift(g,8))
	send_data = bit.bor(send_data,r)
	write_frame(send_data)
	send_data=nil
	check_byte=nil
	collectgarbage()
end

function rgb_led_close()
	gpio.mode(pinClk,gpio.OUTPUT)
	gpio.mode(pinDin,gpio.OUTPUT)
	rgb_led_open(0,0,0)
end
function rgb_led_open(r,g,b)
	write_frame(0x00)
	write_data(b,g,r)
	write_frame(0x00)
end

--mico gpio 17/ pb10/ wifimcu D3
pinClk = 3
--mico gpio 18/ pb9/wifimcu D11
pinDin = 11

gpio.mode(pinClk,gpio.OUTPUT)
gpio.mode(pinDin,gpio.OUTPUT)
rgb_led_open(0,0,0)