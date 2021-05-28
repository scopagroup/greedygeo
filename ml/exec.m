function exec( nodeid, numnodes )
 
       
        g=5;
        opt=setup(g);
        F=opt.F;
        Q=opt.Q;
        m=opt.m;
        M=m*Q;

        H=[0.8 0.05 0.05 0.05 0.05];
        G=[0.1 0.2 0.2 0.4 0.1];
        mesh=0.005;
        PEN=[0.05 0.2;0.1 0.3;0.1 0.3;0.3 0.4];
        PENSET=PENset(PEN,mesh);
        sepPEN = SepPEN1( PENSET, numnodes );     
        


        [BP, cost_BP] = ParallelOneComp(sepPEN{nodeid}, 10, H, G, F, Q, m );

        resultname = ['result-for-node', num2str(nodeid) '.mat' ];

        save( resultname, 'BP', 'cost_BP' )

end