PROGNAME=monitor
COMPORT=/dev/ttyUSB0

$(PROGNAME): monitor.o

monitor.o: monitor.cc

run:
	stty -F $(COMPORT) raw -echo 2000000
	cat $(COMPORT) | ./monitor

clean:
	$(RM) *.o
	$(RM) $(PROGNAME)
