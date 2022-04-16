
import numpy
import matplotlib.pyplot as plt
import os
path='./scaling_data'
savefig=False # set to true to save plot as a png
strong_sizes = [48, 192, 768]
weak_sizes = [4, 64, 256]
colors = ['blue', 'green', 'orange']

sizes = strong_sizes
nsizes = len(sizes)


fig, ax = plt.subplots(ncols=2,nrows=2, figsize=(15,8))
limstrong = [1e-4,1e-1]
limweak = [1e-4,1]
nps = numpy.zeros(nsizes,dtype='float64')
stimes = numpy.zeros(nsizes,dtype='float64')
for i in range(nsizes):
    lstring = str(sizes[i])+' Y-points'
    file = path+'/strong_nn_'+str(sizes[i])
    print(file)
    vars = numpy.loadtxt(file)
    np = vars[:,0]
    time = vars[:,1]
    
    # Create the strong scaling plots
    ax[0,0].plot(np, time, 'o', color=colors[i], label=lstring)
    ax[0,0].set_yscale('log')
    ax[0,0].set_xscale('log')
    ax[0,0].set_title('Strong Scaling Times') 
    ax[0,0].set_ylim(limstrong)
    ax[0,0].set_xlabel('# of Cores')
    ax[0,0].set_ylabel('Walltime (seconds)')

    #Plot an ideal scaling curve for reference
    ideal = np[0]/np*time[0]
    ax[0,0].plot(np,ideal,'-', color=colors[i])    
    
    ax[0,0].legend()
    
    #Next, create the efficiency plots
    eff = ideal/time
    ax[1,0].plot(np,eff, 'o', color=colors[i], label=lstring)
    ax[1,0].set_title('Strong Scaling Efficiency')
    ax[1,0].set_xlabel('# of Cores')
    ax[1,0].set_ylabel('Efficiency')
    ax[1,0].legend()
    

sizes = weak_sizes
nsizes = len(sizes)
for i in range(nsizes):
    lstring = str(sizes[i])+' Y-points per core'
    file = path+'/weak_nn_'+str(sizes[i])
    vars = numpy.loadtxt(file)
    np = vars[:,0]
    time = vars[:,1]
    ax[0,1].plot(np, time, 'o', color=colors[i],label=lstring)
    ax[0,1].set_yscale('log')
    ax[0,1].set_xscale('log')
    ax[0,1].set_title('Weak Scaling Times')     
    ax[0,1].set_ylim(limweak)
    ax[0,1].set_xlabel('# of Cores')
    ax[0,1].set_ylabel('Walltime (seconds)')
    ideal = np*0+time[0]
    ax[0,1].plot(np,ideal,'-') 

    ax[0,1].legend()
    #Now, the efficiency plots
    eff = ideal/time
    ax[1,1].plot(np,eff, 'o', color=colors[i], label=lstring)
    ax[1,1].set_title('Weak Scaling Efficiency')
    ax[1,1].set_xlabel('# of Cores')
    ax[1,1].set_ylabel('Efficiency')
    ax[1,1].legend()
    
plt.tight_layout()
if (savefig):
    plt.savefig('scaling_plots.png')
else:
    plt.show()


