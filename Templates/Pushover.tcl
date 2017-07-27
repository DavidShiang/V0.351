#����������PushOver����By���������
 
#������������
wipe;
model basic -ndm 2 -ndf 3;
file mkdir EQ;
 
#ģ�Ͷ���
node 1 0 0
node 2 0 1000
 
#�߽�����
fix 1 1 1 1; 
#����ˮƽ��������M=G/g
mass 2 200 1.e-9 0.
#����ת�� 
geomTransf Linear 1;
#���嵯��������Ԫ�����element elasticBeamColumn eleTag iNode jNode A E Iz transfTag
element elasticBeamColumn 1 1 2 10000 200000 8333333 1;
 
#�����¼��
recorder Node -file EQ/node2.out -time -node 2 -dof 1 2 3 disp;
recorder Node -file EQ/node1.out -time -node 1 -dof 1 2 3 disp;		
recorder Drift -file EQ/drift.out -time -iNode 1 -jNode 2 -dof 1  -perpDirn 2 ;
 
#�����������
pattern Plain 1 Linear {
   load 2 0. -2000. 0.;			
}
constraints Plain;
numberer Plain;
system BandGeneral;
test NormDispIncr 1.0e-8 6;
algorithm Newton;
integrator LoadControl 0.1;
analysis Static;
analyze 10;
loadConst -time 0.0;
 
#�����������
#������ٶȶ��壨���ڵ����ļ���λ��m/s^2ת����mm/s^2,�Ŵ�1000����
set accelSeries "Series -dt 0.02 -filePath ELCENTRO.DAT -factor 1000";
#ʩ�ӵ�������
pattern UniformExcitation 2 1 -accel $accelSeries;
#�����������ᣨ���ݵ�һ���ͼ��㣩
rayleigh 0. 0. 0. [expr 2*0.02/pow([eigen 1],0.5)];
 
# ��������
constraints Plain;
numberer Plain;
system BandGeneral;	
test NormDispIncr 1.0e-8 10;
algorithm Newton;
integrator Newmark 0.5 0.25 ;
analysis Transient;
analyze 1560 0.02;