//@shadeware
#include <cstdio>
#include <vector>
#include <cmath>
unsigned i,n,Q,j,L;long long u[66],A;int main(){for(;i<448;i++)u[i/7+2]=u[i/7+2]*96+"+.Uy[e^4MAqc>,3Vq8a}n3-teC`p2r/)Fl[2Z)|>Ke2O~7<Co2:Q]dpI23fM5~22\'X S\'}2\"z;})81lu^+vx1s sc[U1g%Wzq+1s3 ?1[1HQoI$^1TH2EaX1cEzV,Z1CHMY7o1DHmqPA1D#4oe]1F&|\'F^1R`5\'k)0{z2\\Oc1<T/G)x10BVH)~1B,ZzW:1)>FZ%$1+[%c\"<0dAd/tP1->\"0M!1;JwZ6!1*%j_y00V6$w!u10I dHR1PXF]r20!?Xhxw1?nbdEr0e-/ZE_0s:6:z.0[}+qG51<y9WfF0.^#nCQ0s)I(d/0XfrAQB10^,7e?0^X\'W4 13M.MfL0"
"5Q2Oz50fxnC)E0V@NGo+0=Z?sS/0I_*[l0\\W)O u1pw[AYJ/A?Xk;g0rbiYbu1*{Pj>f0\'\"aEs60OP;ZHs0zsjvXg0:~BPSu/aWY+&F1_aM,<q"[i]-32;for(i=0;i<64;i++)u[i+2]+=2*u[i+1]-u[i];scanf("%u",&n);Q=sqrt(n)+1e-7,L=n>>24<<24;A=u[(n>>24)+1]+2*!L*!!~-n;std::vector<bool>S(Q/2+1),B(n-L+2);B[1]=!L;for(i=3;i<=Q;i+=2)if(!S[i/2]){for(j=3*i;j<=Q;j+=2*i)S[j/2]=1;for(j=L?(L+i-1)/i*i:2*i;j<=n;j+=i)B[j-L]=1;}for(i=1;i+L<=n;i+=2)B[i]?0:A+=i+L;printf("%llu\n",A);}