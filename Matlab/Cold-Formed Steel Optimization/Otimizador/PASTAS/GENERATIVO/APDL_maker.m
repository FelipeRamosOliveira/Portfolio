function APDL_maker(L,fy,E,Lf,t,A)
%
global node
v=0.3; %COEF DE POISSON 
L=max(L);
%
Titulo=['APDL_',...
        'L=',num2str(L),'Lf=',num2str(Lf),'E=',num2str(E),'t=',num2str(t),'fy=',num2str(fy)...
        ,'.txt'];  
%    
fid = fopen(Titulo,'wt');
%
igual='=';
fprintf(fid,'%s\n','	! ********************************************************** !		');
fprintf(fid,'%s\n','	! INICIAR PRÉ-PROCESSAMENTO		');
fprintf(fid,'%s\n','	! ********************************************************** !		');
fprintf(fid,'%s\n','	FINISH	! Exits normally from a processor	');
fprintf(fid,'%s\n','	/CLEAR,START	! Clears the database	');
fprintf(fid,'%s\n','	/TITLE,STRENGTH OF SYMPLY SUPPORTED CFS UNDER COMPRESSION (S-S)		');
fprintf(fid,'%s\n','	/FILNAME,Plate,0		');
fprintf(fid,'%s\n','	/CWD,''C:\Users\Felipe\Desktop\TESTE''		');
fprintf(fid,'%s\n','			');
fprintf(fid,'%s\n','	/PREP7	! create and set up the model	');
fprintf(fid,'%s\n','	BCSOPTION,,DEFAULT	! Sets memory option for the sparse solver	');
fprintf(fid,'%s\n','			');
fprintf(fid,'%s\n','	! ********************************************************** !		');
fprintf(fid,'%s\n','	! CONFIGURE INTERFACE GRÁFICA		');
fprintf(fid,'%s\n','	! ********************************************************** !		');
fprintf(fid,'%s\n','	/VIEW,1,1,1,1	! Defines the viewing direction for the display	');
fprintf(fid,'%s\n','	/RGB,INDEX,100,100,100, 0   		');
fprintf(fid,'%s\n','	/RGB,INDEX, 80, 80, 80,13   		');
fprintf(fid,'%s\n','	/RGB,INDEX, 60, 60, 60,14   		');
fprintf(fid,'%s\n','	/RGB,INDEX, 0, 0, 0,15  		');
fprintf(fid,'%s\n','	/REPLOT 		');
fprintf(fid,'%s\n','			');
fprintf(fid,'%s\n','	! ********************************************************** !		');
fprintf(fid,'%s\n','	! DECLARE OS PARAMETROS FÍSICOS 		');
fprintf(fid,'%s\n','	! ********************************************************** !		');
fprintf(fid,'%s\n','			');
fprintf(fid,'    L%s %0.2f         ! (mm) COMPRIMENTO\n',igual,L);
fprintf(fid,'    t%s %0.2f            ! (mm) ESPESSURA\n',igual,t);
fprintf(fid,'    E%s %0.2f       ! (N/mm2) MODULO DE ELASTICIDADE\n',igual,E*10^3);
fprintf(fid,'    v%s %0.2f            ! COEF. DE POISSON\n',igual,v);
fprintf(fid,'    fy%s %0.2f         ! (N/mm2) TENSÃO DE ESCOAMENTO\n',igual,fy*10^3);
fprintf(fid,'    A%s %0.2f         ! (mm2) ÁREA BRUTA DA SEÇÃO\n',igual,A);
fprintf(fid,'%s\n','                                                                    ');
fprintf(fid,'%s\n','	N1   = 0        ! NO PARA CONTROLE DE DESLOCAMENTO	');
fprintf(fid,'%s\n','	Umax = 3        ! (mm) DESLOCAMENTO, CRITERIO DE PARADA EM ARCTRM	');
fprintf(fid,'%s\n','	imp  =0.1*t     ! IMPERFEICAO INICIAL	');
fprintf(fid,'%s\n','	TNLA = fy*A	    ! CARREGAMENTO NA ANÁLISE NÃO LINEAR	');
fprintf(fid,'%s\n','			');
fprintf(fid,'%s\n','	! ********************************************************** !		');
fprintf(fid,'%s\n','	! DEFINIR ELEMENTOS SHELL181		');
fprintf(fid,'%s\n','	! ********************************************************** !		');
fprintf(fid,'%s\n','	ET,1,SHELL181              ! Defines a local element type from the element library	');
fprintf(fid,'%s\n','	KEYOPT,1,1,0               ! Sets element key options 	');
fprintf(fid,'%s\n','	KEYOPT,1,3,2	');
fprintf(fid,'%s\n','	KEYOPT,1,8,0	');
fprintf(fid,'%s\n','	KEYOPT,1,9,0	');
fprintf(fid,'%s\n','	KEYOPT,1,10,0  	');
fprintf(fid,'%s\n','			');
fprintf(fid,'%s\n','	! ********************************************************** !		');
fprintf(fid,'%s\n','	! MATERIAL		');
fprintf(fid,'%s\n','	! ********************************************************** !		');
fprintf(fid,'%s\n','	R,1,t, , , , , ,          ! Defines the element real constants.	');
fprintf(fid,'%s\n','	RMORE, , , , , , ,        ! Adds real constants to a set	');
fprintf(fid,'%s\n','	MPTEMP,,,,,,,,            ! Defines a temperature table for material properties	');
fprintf(fid,'%s\n','	MPTEMP,1,0');
fprintf(fid,'%s\n','	MP,EX,1,E                 ! Defines a linear material property as a constant	');
fprintf(fid,'%s\n','	MP,PRXY,1,v');
fprintf(fid,'%s\n','			');
fprintf(fid,'%s\n','	! ********************************************************** !		');
fprintf(fid,'%s\n','	! SEÇÃO		');
fprintf(fid,'%s\n','	! ********************************************************** !		');
fprintf(fid,'%s\n','	SECTYPE,1,SHELL,,perfil   ! Associates section type information with a section ID number		');
fprintf(fid,'%s\n','	SECDATA,t                 ! Describes the geometry of a section	');
fprintf(fid,'%s\n','	SECOFFSET , MID	          ! Defines the section offset for cross sections	');
fprintf(fid,'%s\n','			');
%%
fprintf(fid,'%s\n','	! ********************************************************** !		');
fprintf(fid,'%s\n','	! DEFINIR COORDENADAS DOS ''KEYPOINTS''		');
fprintf(fid,'%s\n','	! ********************************************************** !		');
fprintf(fid,'%s\n','			');
fprintf(fid,'%s\n','    !LINHA INICIAL');
%---------------------------------------------------------------------------
for ii=1:length(node(:,1))
if node(ii,1)<=9;    
fprintf(fid,'\n         K,10%d , %.2f , %.2f , 0',ii,node(ii,2),node(ii,3));
else node(ii,1)>9; 
fprintf(fid,'\n         K,1%d , %.2f , %.2f ,  0',ii,node(ii,2),node(ii,3));    
end
end
%---------------------------------------------------------------------------
fprintf(fid,'%s\n','			');
fprintf(fid,'%s\n','			');
fprintf(fid,'%s\n','    !LINHA CENTRAL');
fprintf(fid,'%s\n','			');
for ii=1:length(node(:,1))
if node(ii,1)<=9;    
fprintf(fid,'\n         K,20%d ,    %.2f ,  %.2f , L/2 ',ii,node(ii,2),node(ii,3));
else node(ii,1)>9; 
fprintf(fid,'\n         K,2%d  ,    %.2f ,  %.2f , L/2 ',ii,node(ii,2),node(ii,3));    
end
end
%---------------------------------------------------------------------------
fprintf(fid,'%s\n','			');
fprintf(fid,'%s\n','			');
fprintf(fid,'%s\n','    !LINHA FINAL');
fprintf(fid,'%s\n','			');
for ii=1:length(node(:,1))
if node(ii,1)<=9;    
fprintf(fid,'\n         K,30%d ,    %.2f ,  %.2f , L',ii,node(ii,2),node(ii,3));
else node(ii,1)>9; 
fprintf(fid,'\n         K,3%d ,     %.2f ,  %.2f , L',ii,node(ii,2),node(ii,3));    
end
end
%---------------------------------------------------------------------------
fprintf(fid,'%s\n','			');
fprintf(fid,'%s\n','			');
%%
fprintf(fid,'%s\n','	! ********************************************************** !		');
fprintf(fid,'%s\n','	! DEFINIR AREAS         ');
fprintf(fid,'%s\n','	! ********************************************************** !		');
fprintf(fid,'%s\n','	*DO,I,1,16,1            ');
fprintf(fid,'%s\n','	  *DO,J,1,2,1           ');
fprintf(fid,'%s\n','	a1 = 100*J+I            ');
fprintf(fid,'%s\n','	a2 = 100*J+I+1          ');
fprintf(fid,'%s\n','	a3 = 100*(J+1)+I+1		');
fprintf(fid,'%s\n','	a4 = 100*(J+1)+I		');
fprintf(fid,'%s\n','	A,a1,a2,a3,a4           ');
fprintf(fid,'%s\n','	  *ENDDO                ');
fprintf(fid,'%s\n','	*ENDDO                  ');
fprintf(fid,'%s\n','                            ');
%%
fprintf(fid,'%s\n','	! ********************************************************** !		');
fprintf(fid,'%s\n','	! MALHA		');
fprintf(fid,'%s\n','	! ********************************************************** !		');
fprintf(fid,'%s\n','	ASEL ,ALL           ! Selects a subset of areas	');
fprintf(fid,'%s\n','	AATT ,1,1,1,0,1     ! Associates element attributes with the selected, unmeshed areas	');
fprintf(fid,'%s\n','			');
fprintf(fid,'%s\n','	MSHKEY,0            ! Specifies whether free meshing or mapped meshing should be used to mesh a model.	');
fprintf(fid,'%s\n','	AESIZE,ALL,5        ! Specifies the element size to be meshed onto areas	');
fprintf(fid,'%s\n','	AMESH,ALL           ! Generates nodes and area elements within areas	');
fprintf(fid,'%s\n','			');
%%
fprintf(fid,'%s\n','	! ********************************************************** !		');
fprintf(fid,'%s\n','	! CONCLUIR PRÉ-PROCESSAMENTO		');
fprintf(fid,'%s\n','	! INICIAR PROCESSAMENTO		');
fprintf(fid,'%s\n','	! ********************************************************** !		');
fprintf(fid,'%s\n','	FINISH          ! Exits normally from a processor	');
fprintf(fid,'%s\n','	/SOLU           ! Enters the solution processor	');
fprintf(fid,'%s\n','	ANTYPE,STATIC 	! Specifies the analysis type and restart status	');
fprintf(fid,'%s\n','			');
%%
fprintf(fid,'%s\n','	! ********************************************************** !		');
fprintf(fid,'%s\n','	! APOIOS		');
fprintf(fid,'%s\n','	! ********************************************************** !		');
fprintf(fid,'%s\n','	LSEL,S,LOC,Z,0 	! Selects a subset of lines	');
fprintf(fid,'%s\n','	LSEL,A,LOC,Z,L 	! Selects a subset of lines	');
fprintf(fid,'%s\n','	DL,ALL,,UX,0 	! Defines DOF constraints on lines	');
fprintf(fid,'%s\n','	DL,ALL,,UY,0 	! Defines DOF constraints on lines	');
fprintf(fid,'%s\n','			');
fprintf(fid,'%s\n','	DK,209,UZ,0	! Defines DOF constraints at keypoints	');
fprintf(fid,'%s\n','			');
%%
fprintf(fid,'%s\n','	! ********************************************************** !		');
fprintf(fid,'%s\n','	! CARREGAMENTOS		');
fprintf(fid,'%s\n','	! ********************************************************** !		');
fprintf(fid,'%s\n','	LSEL,S,LOC,Z,0 	! Selects a subset of lines	');
fprintf(fid,'%s\n','	LSEL,A,LOC,Z,L 	! Selects a subset of lines	');
fprintf(fid,'%s\n','	SFL,ALL,PRES,t 	! Specifies surface loads on lines of an area');
fprintf(fid,'%s\n','			');
fprintf(fid,'%s\n','	! ********************************************************** !		');
fprintf(fid,'%s\n','	! CONFIGURE ANÁLISE LINEAR ELÁSTICA		');
fprintf(fid,'%s\n','	! ********************************************************** !		');
fprintf(fid,'%s\n','	ANTYPE,STATIC 	! Specifies the analysis type and restart status 	');
fprintf(fid,'%s\n','	PSTRES,ON 	! Specifies whether prestress effects are calculated or included.	');
fprintf(fid,'%s\n','	SOLVE	! Starts a solution	');
fprintf(fid,'%s\n','	FINISH	! Exits normally from a processor	');
fprintf(fid,'%s\n','			');
%%
fprintf(fid,'%s\n','	! ********************************************************** !		');
fprintf(fid,'%s\n','	! CONFIGURE ANÁLISE DE ESTABILIDADE ELÁSTICA		');
fprintf(fid,'%s\n','	! ********************************************************** !		');
fprintf(fid,'%s\n','	/SOLU	! Enters the solution processor	');
fprintf(fid,'%s\n','	ANTYPE,BUCKLE	! Specifies the analysis type and restart status 	');
fprintf(fid,'%s\n','	BUCOPT,LANB,2 	! Specifies buckling analysis options	');
fprintf(fid,'%s\n','			');
fprintf(fid,'%s\n','	LSEL,S,LOC,Z,0 	! Selects a subset of lines	');
fprintf(fid,'%s\n','	LSEL,A,LOC,Z,L 	! Selects a subset of lines	');
fprintf(fid,'%s\n','	DL,ALL,,UX,0 	! Defines DOF constraints on lines	');
fprintf(fid,'%s\n','	DL,ALL,,UY,0 	! Defines DOF constraints on lines	');
fprintf(fid,'%s\n','			');
fprintf(fid,'%s\n','	DK,209,UZ,0		');
fprintf(fid,'%s\n','			');
fprintf(fid,'%s\n','	SOLVE       ! Starts a solution                 ');
fprintf(fid,'%s\n','	FINISH      ! Exits normally from a processor	');
fprintf(fid,'%s\n','			');
fprintf(fid,'%s\n','	/SOLU       ! Enters the solution processor	'    );
fprintf(fid,'%s\n','	EXPASS,ON 	! Specifies an expansion pass of an analysis, ON - An expansion pass will be performed.	');
fprintf(fid,'%s\n','	MXPAND,1 	! Specifies the number of modes to expand and write for a modal or buckling analysis	');
fprintf(fid,'%s\n','	SOLVE       ! Starts a solution                 ');
fprintf(fid,'%s\n','	FINISH      ! Exits normally from a processor	');
fprintf(fid,'%s\n','			');
fprintf(fid,'%s\n','	/POST1      ! Enters the database results postprocessor	');
fprintf(fid,'%s\n','	!SET,LIST	! Defines the data set to be read from the results file	');
fprintf(fid,'%s\n','			');
fprintf(fid,'%s\n','	SET,LAST	! Defines the data set to be read from the results file	');
fprintf(fid,'%s\n','	PLDISP      ! Displays the displaced structure	');
fprintf(fid,'%s\n','	FINISH      ! Exits normally from a processor	');
fprintf(fid,'%s\n','			');
fprintf(fid,'%s\n','	/POST1      ! Enters the database results postprocessor	');
fprintf(fid,'%s\n','	PLNSOL,U,SUM                ');
fprintf(fid,'%s\n','                                ');
fprintf(fid,'%s\n','	! ********************************************************** !		');
fprintf(fid,'%s\n','	! OUTPUT: JPEG              ');
fprintf(fid,'%s\n','	! ********************************************************** !		');
fprintf(fid,'%s\n','	!/POST1                     ');
fprintf(fid,'%s\n','	!/VIEW,  1, 1.0, 0.3, 0.3	');
fprintf(fid,'%s\n','	!/ANG,   1, 90,XM           ');
fprintf(fid,'%s\n','	!/REPLOT                    ');
fprintf(fid,'%s\n','                                ');
fprintf(fid,'%s\n','	/SHOW,JPEG,,0               ');
fprintf(fid,'%s\n','	JPEG,QUAL,75,               ');
fprintf(fid,'%s\n','	JPEG,ORIENT,HORIZ           ');
fprintf(fid,'%s\n','	JPEG,COLOR,2                ');
fprintf(fid,'%s\n','	JPEG,TMOD,1                 ');
fprintf(fid,'%s\n','	/GFILE,800,                 ');
fprintf(fid,'%s\n','	/REPLOT                     ');
fprintf(fid,'%s\n','	/SHOW,CLOSE                 ');
fprintf(fid,'%s\n','	/DEVICE,VECTOR,0            ');
fprintf(fid,'%s\n','			');
fprintf(fid,'%s\n','	! ********************************************************** !		');
fprintf(fid,'%s\n','	! IMPERFEIÇÃO INICIAL (MODO DE FLAMBAGEM)		');
fprintf(fid,'%s\n','	! ********************************************************** !		');
fprintf(fid,'%s\n','	/PREP7                   ! Create and set up the model	');
fprintf(fid,'%s\n','	UPGEOM,imp,1,1,Plate,rst ! Adds displacements from a previous analysis and 	');
fprintf(fid,'%s\n','                             ! Updates the geometry of the finite element model 	');
fprintf(fid,'%s\n','                             ! To the deformed configuration	');
fprintf(fid,'%s\n','	CDWRITE,db,Plate,cdb     ! Writes geometry and load database items to a file	');
fprintf(fid,'%s\n','	FINISH                   ! Exits normally from a processor	');
fprintf(fid,'%s\n','			');
fprintf(fid,'%s\n','	/POST1                   ! Enters the database results postprocessor	');
fprintf(fid,'%s\n','	PLDISP,2                 ! Displays the displaced structure	');
fprintf(fid,'%s\n','			');
fprintf(fid,'%s\n','	! ********************************************************** !		');
fprintf(fid,'%s\n','	! CONFIGURE ANÁLISE NÃO LINEAR		');
fprintf(fid,'%s\n','	! ********************************************************** !		');
fprintf(fid,'%s\n','	/PREP7                   ! Create and set up the model	');
fprintf(fid,'%s\n','	TB,BISO,1,1,2            ! Activates a data table for material properties or special element input	');
fprintf(fid,'%s\n','	TBTEMP,0');
fprintf(fid,'%s\n','	TBDATA,,fy               ! Defines data for the material data table.	'            );
fprintf(fid,'%s\n','                                                                        ');
fprintf(fid,'%s\n','	/SOLU                    ! Enters the solution processor	'                            );

%fprintf(fid,'%s\n','	N1 = NODE(bfsup,bw-bssup,L/2)	! DADOS DO MEIO DO VAO NO ENRIJECEDOR SUPERIOR	');
fprintf(fid,'\n    N1=NODE( %.2f , %.2f ,L/2)    ! No de referência',node(14,2),node(14,3));
fprintf(fid,'%s\n','                                                                        ');
fprintf(fid,'%s\n','	ANTYPE,STATIC            ! Specifies the analysis type and restart status	');
fprintf(fid,'%s\n','	NLGEOM,ON                ! Includes large-deflection effects in a static or full transient analysis	');
fprintf(fid,'%s\n','	OUTRES,ERASE             ! Controls the solution data written to the database	');
fprintf(fid,'%s\n','	OUTRES,ALL,ALL           ! Controls the solution data written to the database	');
fprintf(fid,'%s\n','	ARCLEN,ON,1,0.0001       ! Activates the arc-length method	');
fprintf(fid,'%s\n','	!ARCTRM,L                ! Controls termination of the solution when the arc-length method is used.	');
fprintf(fid,'%s\n','	ARCTRM,U,Umax,N1,UY		');
fprintf(fid,'%s\n','	DELTIM,0.1,0,0           ! Specifies the time step sizes to be used for the current load step	');
fprintf(fid,'%s\n','	AUTOTS,OFF               ! Specifies whether to use automatic time stepping or load stepping	');
fprintf(fid,'%s\n','	TIME=1                   ! Sets the time for a load step	');
fprintf(fid,'%s\n','	NEQIT,26,FORCE           ! Specifies the maximum number of equilibrium iterations for nonlinear analyses.	');
fprintf(fid,'%s\n','	!NCNV,2,0,0,0,0          ! Sets the key to terminate an analysis	');
fprintf(fid,'%s\n','	CNVTOL,F,,0.00001,2,0.01 ! Sets convergence values for nonlinear analyses		');
fprintf(fid,'%s\n','                ');
fprintf(fid,'%s\n','	/PREP7                   ! create and set up the model	');
fprintf(fid,'%s\n','	LSEL,S,LOC,Z,0           ! Selects a subset of lines	');
fprintf(fid,'%s\n','	LSEL,A,LOC,Z,L                                          ');
fprintf(fid,'%s\n','	SFL,ALL,PRES,TNLA        ! Specifies surface loads on lines of an area	');
fprintf(fid,'%s\n','	FINISH                   ! Exits normally from a processor	');
fprintf(fid,'%s\n','                ');
fprintf(fid,'%s\n','	/SOL                     ! Enters the solution processo	');
fprintf(fid,'%s\n','	SOLVE                    ! Starts a solution	');
fprintf(fid,'%s\n','	FINISH		');
fprintf(fid,'%s\n','	! ********************************************************** !		');
fprintf(fid,'%s\n','	! MONITORAR DESLOCAMENTOS		');
fprintf(fid,'%s\n','	! ********************************************************** !		');
fprintf(fid,'%s\n','	/POST26                  ! Enters the time-history results postprocessor	');
fprintf(fid,'%s\n','	NSOL,2,N1,U,Y,MESA,      ! Specifies nodal data to be stored from the results file	');
fprintf(fid,'%s\n','	STORE,MERGE              ! Stores data in the database for the defined variables.	');
fprintf(fid,'%s\n','	XVAR,1                   ! Specifies the X variable to be displayed	');
fprintf(fid,'%s\n','	PLVAR,2,                 ! Displays up to ten variables in the form of a graph	');
fprintf(fid,'%s\n','			');
fprintf(fid,'%s\n','	FINISH                   ! Exits normally from a processor	');

fclose(fid);
end