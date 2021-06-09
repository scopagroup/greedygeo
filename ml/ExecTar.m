function ExecTar( nodeid, numnodes )
 
       % nodeid=1;
       % numnodes=6;
        g=3;
        opt=setup(g);
        F=opt.F;
        Q=opt.Q;
        m=opt.m;
        M=m*Q;
        delta=0.02;
        TAR=[0.05 0.5;0.2 0.7];
        [TARSET] = TarSet(TAR,delta);
        H=[0.99, 0.005,0.005];
        mesh=0.001;
        
        tic
        %PENSET=PENset(PEN,mesh);
        sepTAR = SepTAR( TARSET, numnodes );     
       
        [Results] = ParallelOnTar(sepTAR{nodeid},6,H,F,Q,m,mesh);
    
        time=toc
        resultname = ['result-for-Target-nodelocal-', num2str(nodeid) '.mat' ];

        save( resultname, 'Results','time','F')

end