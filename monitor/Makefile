PROGNAME=monitor
COMPORT=/dev/ttyUSB0
COMPORT2=/dev/ttyUSB1

$(PROGNAME): monitor.o

monitor.o: monitor.cc

run:
	stty -F $(COMPORT) raw -echo 2000000
	cat $(COMPORT) | ./monitor
fast:
	stty -F $(COMPORT) raw -echo 4000000
	./monitor < $(COMPORT)
fast2:
	stty -F $(COMPORT2) raw -echo 4000000
	./monitor < $(COMPORT2)

clean:
	$(RM) *.o
	$(RM) $(PROGNAME)
