all: main

CXX := g++
LD := ${CXX}

# Flags to enable link-time optimization and GDB
LTO := -flto
ENABLE_DGB :=

HOTS_HOME := ../..
MICA_HOME := ../../mica2/src

INC	:= -I ${HOTS_HOME} -I ${MICA_HOME}

#DEBUG := -DNDEBUG
CPPFLAGS := ${ENABLE_DGB} ${LTO} -O3 ${DEBUG} -std=c++11 ${INC} -Wall -Werror \
	-Wno-unused-result -Wno-unused-value -Wno-unused-function -Wno-aligned-new -Wno-class-memaccess\
	-Winline

LDFLAGS := ${ENABLE_DGB} ${LTO} -O3 -I/usr/local/include -L/usr/local/lib -libverbs -lrt -pthread -lmemcached -lnuma \
	-lpapi -lboost_system -lboost_coroutine

src := ${HOTS_HOME}/libhrd/hrd_conn.o ${HOTS_HOME}/libhrd/hrd_util.o \
	${HOTS_HOME}/rpc/rpc.o ${HOTS_HOME}/rpc/rpc_datapath.o \
	main.o worker.o

# Handle MICA differently. MICA relies on DNDEBUG to disable datapath asserts.
MICA_DEBUG := -DNDEBUG
mica_src := ${MICA_HOME}/mica/util/config.o \
	${MICA_HOME}/mica/util/cityhash/city_mod.o
${mica_src} : CPPFLAGS += ${MICA_DEBUG}

main: ${src} ${mica_src}
	${LD} -o $@ $^ ${LDFLAGS}

PHONY: clean
clean:
	rm -f *.o main ${src} ${mica_src}
