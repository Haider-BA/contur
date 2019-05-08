      SUBROUTINE PERFC
C
C     TO OBTAIN THE INVISCID CONTOUR OF THE NOZZLE
C
      IMPLICIT REAL*8(A-H,O-Z)
      COMMON /GG/ GAM,GM,G1,G2,G3,G4,G5,G6,G7,G8,G9,GA,RGA,QT
      COMMON /CLINE/ AXIS(5,150),TAXI(5,150),WIP,X1,FRIP,ZONK,SEO,CSE
      COMMON /COORD/ S(200),FS(200),WALTAN(200),SD(200),WMN(200),TTR(200
     1),DMDX(200),SPR(200),DPX(200),SECD(200),XBIN,XCIN,GMA,GMB,GMC,GMD
      COMMON /WORK/ A(5,150),B(5,150),FINAL(5,150),WALL(5,200),WAX(200),
     1WAY(200),WAN(200)
      COMMON /PROP/ AR,ZO,RO,VISC,VISM,SFOA,XBL,CONV
      COMMON /PARAM/ ETAD,RC,AMACH,BMACH,CMACH,EMACH,GMACH,FRC,SF,WWO,WW
     1OP,QM,WE,CBET,XE,ETA,EPSI,BPSI,XO,YO,RRC,SDO,XB,XC,AH,PP,SE,TYE,XA
      COMMON /TROAT/ FC(6,51)
      COMMON /CONTR/ ITLE(3),IE,LR,IT,JB,JQ,JX,KAT,KBL,KING,KO,LV,NOCON,
     1IN,MC,MCP,IP,IQ,ISE,JC,M,MP,MQ,N,NP,NF,NUT
      DIMENSION CHAR(6,150), SU(150), WDX(200), WTAN(200), SCDF(200), YI
     1(100)
      DATA ZRO/0.0D+0/,ONE/1.D+0/,TWO/2.D+0/,SIX/6.D+0/,HALF/5.D-1/
      DATA IFR/4HFIRS/,IWL/4HWALL/,LST/4HLAST/,IBL/4H    /,THR/3.D+0/
      CALL OREZ (A,4*750+250)
      CPSI=G2*DATAN(G4*CBET)-DATAN(CBET)
      IF (JQ.GT.0) GO TO 6
      IF (LR.EQ.0) GO TO 4
C
C     THROAT CHARACTERISTIC VALUES
      SUMAX=(SE/SEO)**(IE+1)
      IF (QM.EQ.ONE) SUMAX=ONE
      LQ=ZONK*(LR-1)+1
      NL=N+LQ-1
      DO 3 J=1,LQ
      IF (QM.NE.ONE) GO TO 1
      FC(1,J)=FC(1,J)*SE+XO
      FC(2,J)=FC(2,J)*SE
1     FINAL(1,J)=FC(1,J)
      FINAL(2,J)=FC(2,J)
      FINAL(3,J)=FC(3,J)
      FINAL(4,J)=FC(4,J)
      FINAL(5,J)=FC(5,J)
      IF (MQ.LT.0) GO TO 3
      IF (J.GT.1) GO TO 2
      WRITE (6,93) ITLE
      WRITE (6,99) IBL
2     XMU=CONV*DASIN(ONE/FINAL(3,J))
      PSI=CONV*FINAL(4,J)
      AN=CONV*FINAL(5,J)
      XINCH=SF*FINAL(1,J)+FRIP
      YINCH=SF*FINAL(2,J)
      WRITE (6,103) J,(FINAL(K,J),K=1,3),XMU,PSI,AN,XINCH,YINCH
      IF (MOD(J,10).EQ.0) WRITE (6,98)
3     SU(J)=FC(6,J)/SUMAX
4     IF (ISE.EQ.0) GO TO 8
C
C     INITIAL CHARACTERISTIC VALUES IF NON-RADIAL FLOW
      DO 5 K=1,M
      A(2,K)=(K-1)*TYE/(M-1)
      A(1,K)=A(2,K)*CBET+XE
      A(3,K)=CMACH
      A(4,K)=CPSI
5     A(5,K)=ZRO
      GO TO 10
C
C     FINAL CHARACTERISTIC VALUES IF RADIAL FLOW
6     NL=N+NP-1
      FN=NP-1
      DO 7 JJ=1,NP
      IF (IE.EQ.0) F=(JJ-1)/FN
      IF (IE.EQ.1) F=TWO*DSIN(HALF*ETA*(JJ-1)/FN)/SE
      FINAL(2,JJ)=F*TYE
      FINAL(1,JJ)=FINAL(2,JJ)*CBET+XC
      FINAL(3,JJ)=CMACH
      FINAL(4,JJ)=CPSI
      FINAL(5,JJ)=ZRO
7     SU(JJ)=F**(IE+1)
C
C     INITIAL CHARACTERISTIC VALUES IF RADIAL FLOW
8     EM=ETA/(M-1)
      DO 9 K=1,M
      T=(K-1)*EM
      IF (IP.EQ.0) XM=FMV(EPSI+T/QT)
      IF (IP.NE.0) XM=FMV(BPSI-T/QT)
      R=((G6+G5*XM**2)**GA/XM)**QT
      XBET=DSQRT(XM**2-ONE)
      A(1,K)=R*DCOS(T)
      A(2,K)=R*DSIN(T)
      A(3,K)=XM
      A(4,K)=G2*DATAN(G4*XBET)-DATAN(XBET)
9     A(5,K)=T
      IF (IE.EQ.1 .AND. IP.EQ.0) A(5,1)=TAXI(5,1)
      IF (IE.EQ.1 .AND. IP.NE.0) A(5,1)=AXIS(5,1)
10    DO 11 J=1,5
11    WALL(J,1)=A(J,M)
      LINE=1
      IF (MQ.LT.0)GO TO 14
      IF (ISE.EQ.1) GO TO 12
      IF (JQ.EQ.0) WRITE (6,91) ITLE
      IF (JQ.EQ.1) WRITE (6,94) ITLE
      GO TO 13
12    WRITE (6,102) ITLE
13    WRITE (6,106) LINE
14    SU(1)=ZRO
      IF (IE.EQ.0) BX=ONE/SE
      NN=1
      DO 15 K=1,M
      DO 15 J=1,5
15    B(J,K)=A(J,K)
      LAST=M-1
      GO TO 20
16    LAST=M
      LINE=2
      IF (IP.NE.0) GO TO 38
17    DO 18 J=1,5
18    B(J,1)=TAXI(J,LINE)
      DO 19 J=1,LAST
      K=J
      CALL OFELD(A(1,K),B(1,K),B(1,K+1),NOCON)
      IF (NOCON.NE.0) GO TO 83
19    CONTINUE
20    LASTP=LAST+1
      IF (LINE.LT.LASTP) LP=LINE
      NK=1+LP/52
      LA=CONV*DASIN(ONE/B(3,NN))
      IPRNT=0
      ICHAR=0
      IF (JC.EQ.0) GO TO 21
      KC=IABS(JC)
      IF (JC.GT.0 .AND. JQ.NE.0) GO TO 21
      IF (JC.LT.0 .AND. JQ.EQ.0) GO TO 21
      ICHAR=1
      IF (KC.GT.100 .AND. KC.LT.101+LINE) IPRNT=1
      IF (NN.EQ.1 .AND. MOD(LINE-1,KC).EQ.0) IPRNT=1
      IF (NN.GT.1 .AND. MOD(NN-1,KC).EQ.0) IPRNT=1
21    DO 27 J=NN,LASTP
      IF (IE.EQ.1) BX=TWO*B(2,J)/SE**2
      XM=B(3,J)
      XMUR=DASIN(ONE/XM)
      XMU=CONV*XMUR
      PSI=B(4,J)*CONV
      AN=B(5,J)*CONV
      IF (B(2,J).EQ.ZRO) AN=ZRO
      IF (IP.EQ.0 .OR. LA.GT.45) GO TO 22
      S(J)=B(1,NN)-B(1,J)
C     MASS INTEGRATION WITH  RESPECT  TO  X
      DSX=ONE/DCOS(B(5,J)-XMUR)
      IF (B(2,J).EQ.ZRO) DSX=XM/DSQRT(XM**2-ONE)
      GO TO 23
22    S(J)=B(2,J)-B(2,NN)
C     MASS INTEGRATION WITH RESPECT TO Y
      IF (IP.EQ.0) DSX=ONE/DSIN(XMUR+B(5,J))
      IF (IP.NE.0) DSX=ONE/DSIN(XMUR-B(5,J))
      IF (B(2,J).EQ.ZRO) DSX=XM
23    IF (ICHAR.EQ.0 .OR. J.NE.LINE) GO TO 24
      CHAR(1,J)=B(1,J)
      CHAR(2,J)=B(2,J)
      CHAR(3,J)=XM
      CHAR(4,J)=XMU
      CHAR(5,J)=PSI
      CHAR(6,J)=AN
24    FS(J)=DSX*BX/(G6+G5*XM**2)**GA
      IF (MQ.GE.0 .AND. LINE.EQ.1) GO TO 25
      IF (IPRNT.EQ.0) GO TO 27
      IF (J.GT.NN) GO TO 25
      IF (IP.EQ.0) WRITE (6,104) ITLE
      IF (IP.NE.0) WRITE (6,105) ITLE
      WRITE (6,106) LINE
25    IF ((NK.GT.1) .AND. (MOD(J,NK).EQ.0)) GO TO 26
      XINCH=SF*B(1,J)+FRIP
      YINCH=SF*B(2,J)
      WRITE (6,103) J,B(1,J),B(2,J),XM,XMU,PSI,AN,XINCH,YINCH
26    IF (MOD(J,10*NK).EQ.0) WRITE (6,98)
27    CONTINUE
C
C     INTEGRATION AND INTERPOLATION FOR MASS FLOW
      SA=ZRO
      SB=ZRO
      SC=ZRO
      SUM=SU(NN)
      KAN=(LASTP-NN)/2
      DO 28 J=1,KAN
      K=NN+2*J
      KT=K
      AS=S(K-1)-S(K-2)
      BS=S(K)-S(K-1)
      CS=AS+BS
      S1=(TWO-BS/AS)*CS/SIX
      S3=(TWO-AS/BS)*CS/SIX
      S2=CS-S1-S3
      ADD=S1*FS(K-2)+S2*FS(K-1)+S3*FS(K)
      SUM=ADD+SUM
      IF (LINE.EQ.1) GO TO 28
      DEL=ONE-SUM
      IF (DEL) 30,29,28
28    CONTINUE
      IF (LINE.EQ.1) WRITE (6,96) SUM
      IF (LINE.EQ.1) GO TO 16
      BS=S(K+1)-S(K)
      KT=K+1
      DN=TWO*DEL/BS
      SC=DN/(FS(K)+DSQRT(FS(K)**2+(FS(KT)-FS(K))*DN))
      SB=ONE-SC
      GO TO 34
29    SC=ONE
      GO TO 34
30    S2=BS*(TWO+CS/AS)/SIX
      S3=BS*(TWO+AS/CS)/SIX
      S1=BS-S2-S3
      BDD=S1*FS(K-2)+S2*FS(K-1)+S3*FS(K)
      IF (BDD+DEL) 31,32,33
31    DN=TWO*(ADD+DEL)/AS
      SB=DN/(FS(K-2)+DSQRT(FS(K-2)**2+(FS(K-1)-FS(K-2))*DN))
      SA=ONE-SB
      GO TO 34
32    SB=ONE
      GO TO 34
33    DN=TWO*DEL/BS
      SC=ONE+DN/(FS(K)+DSQRT(FS(K)**2+(FS(K)-FS(K-1))*DN))
      SB=ONE-SC
34    DO 35 J=1,5
35    WALL(J,LINE)=B(J,KT-2)*SA+B(J,KT-1)*SB+B(J,KT)*SC
      IF (IPRNT.EQ.1) WRITE (6,107) (WALL(J,LINE),J=1,3)
      LAST=KT
      IF (N-LINE) 42,41,36
36    LINE=LINE+1
      DO 37 K=1,5
      DO 37 L=1,150
37    A(K,L)=B(K,L)
      IF (IP.EQ.0) GO TO 17
38    DO 39 J=1,5
39    B(J,1)=AXIS(J,LINE)
      DO 40 J=1,LAST
      K=J
      CALL OFELD (B(1,K),A(1,K),B(1,K+1),NOCON)
      IF (NOCON.NE.0) GO TO 83
40    CONTINUE
      GO TO 20
41    IF (IP.NE.0) GO TO 42
      IF (LR.EQ.0 .OR. IT.NE.0) GO TO 49
42    IF (LINE.EQ.NL-1) GO TO 48
      NN=NN+1
      LINE=LINE+1
      DO 43 K=1,5
      DO 43 L=1,150
43    A(K,L)=B(K,L)
      DO 44 K=1,5
      DO 44 L=1,150
44    B(K,L)=FINAL(K,L)
      IF ((LR.NE.0) .AND. (JQ.EQ.0)) GO TO 46
      DO 45 J=NN,LAST
      K=J
      CALL OFELD(B(1,K),A(1,K),B(1,K+1),NOCON)
      IF (NOCON.NE.0) GO TO 83
45    CONTINUE
      GO TO 20
46    DO 47 J=NN,LAST
      K=J
      CALL OFELD(A(1,K),B(1,K),B(1,K+1),NOCON)
      IF (NOCON.NE.0) GO TO 83
47    CONTINUE
      GO TO 20
48    IF (IP.NE.0) GO TO 64
C
C     INTEGRATION OF SLOPES
49    IB=1
      IF (IABS(JB).GT.1) IB=2
      LT=0
      IF (IT.NE.0) LT=IB
      NUT=(LINE-1)/IB+2-LT
      WALL(1,LINE+1)=XO
      WALL(5,LINE+1)=ZRO
      YI(NUT)=WALL(2,1)
      Y=YI(NUT)
      LIN=2*((LINE-LT)/2)
      DO 50 J=2,LIN,2
      I=NUT-J
      SS=WALL(1,J)-WALL(1,J-1)
      TT=WALL(1,J+1)-WALL(1,J)
      ST=SS+TT
      S1=SS*(TWO+TT/ST)/SIX
      S2=SS*(TWO+ST/TT)/SIX
      S3=SS-S1-S2
      T3=TT*(TWO+SS/ST)/SIX
      T2=TT*(TWO+ST/SS)/SIX
      T1=TT-T2-T3
      Y=Y+S1*DTAN(WALL(5,J-1))+S2*DTAN(WALL(5,J))+S3*DTAN(WALL(5,J+1))
      IF (IB.EQ.1) YI(I+1)=Y
      Y=Y+T1*DTAN(WALL(5,J-1))+T2*DTAN(WALL(5,J))+T3*DTAN(WALL(5,J+1))
      IF (IB.EQ.1) YI(I)=Y
      IF (IB.EQ.2) YI(I+J/2)=Y
50    CONTINUE
      IF (LR.NE.0 .AND. LINE.EQ.LIN) GO TO 51
      X=WALL(1,LINE-LT)-XO
      YI(1)=YI(2)-X*(DTAN(WALL(5,LINE-LT))+HALF*X*SDO)/THR
51    DO 52 L=2,NUT
      JJ=1+IB*(NUT-L)
      WAX(L)=WALL(1,JJ)
      WAY(L)=WALL(2,JJ)
      WMN(L)=WALL(3,JJ)
      WAN(L)=CONV*WALL(5,JJ)
52    WALTAN(L)=DTAN(WALL(5,JJ))
      WAX(1)=XO
      WAY(1)=YO
      WAN(1)=ZRO
      WMN(1)=WWO/DSQRT(G7-G8*WWO**2)
      WALTAN(1)=ZRO
      IF (NF.GE.0) GO TO 54
C
C     SMOOTH UPSTREAM CONTOUR IF DESIRED
      CALL NEO
      DO 53 J=1,NUT
53    WALTAN(J)=DTAN(WAN(J)/CONV)
54    CALL SCOND (WAX,WALTAN,SECD,NUT)
      SECD(1)=SDO
      SECD(NUT)=ZRO
      KO=NUT+MP
      IF (MP.EQ.0) GO TO 56
C
C     RADIAL FLOW SECTION COORDINATES
      SNE=DSIN(ETA)
      TNE=DTAN(ETA)
      DM=(AMACH-GMACH)/MP
      DO 55 L=1,MP
      LL=NUT+L
      WMN(LL)=GMACH+L*DM
      RL=((G5*WMN(LL)**2+G6)**GA/WMN(LL))**QT
      WAX(LL)=RL*CSE
      WAY(LL)=RL*SNE
      WAN(LL)=ETAD
      WALTAN(LL)=TNE
55    SECD(LL)=ZRO
56    IF (MQ.LT.0) GO TO 60
      IF (JC.LE.0) GO TO 58
      WRITE (6,105) ITLE
      WRITE (6,99) LST
      DO 57 K=1,LP,NK
      I=(K-1)/NK+1
      XINCH=SF*CHAR(1,K)+FRIP
      YINCH=SF*CHAR(2,K)
      WRITE (6,103) K,(CHAR(J,K),J=1,6),XINCH,YINCH
57    IF (MOD(I,10).EQ.0) WRITE (6,98)
58    IF (ISE.EQ.0) WRITE (6,91) ITLE
      IF (ISE.EQ.1) WRITE (6,102) ITLE
      WRITE (6,84) RC,ETAD,AMACH,BMACH,CMACH,EMACH,MC,AH
      IF (NOCON.NE.0) GO TO 59
      WRITE (6,100) IWL
      WRITE (6,85) (K,WAX(K),WAY(K),WMN(K),WAN(K),WALTAN(K),SECD(K),K=1,
     1NUT)
      IF ((LR.EQ.0) .AND. (N.LT.42)) GO TO 59
      IF ((LR.NE.0) .AND. (N+LR.LT.27)) GO TO 59
      NOCON=1
      GO TO 58
59    WRITE (6,87)
      NOCON=0
C
C     COMPARISON OF CONTOUR WITH PARABOLA ANO HYPERBOLA
60    DO 62 J=1,NUT
      XS=(WAX(J)-XO)/YO
      XS2=XS**2
      XS3=XS**3
      YS=WAY(J)/YO
      YE=YI(J)/YO
      PS=ONE+HALF*XS2*RRC
      DHP=ONE+XS2*RRC
      HS=DSQRT(DHP)
      IF (J.GT.1) GO TO 61
      IF (MQ.LT.0) GO TO 62
      WRITE (6,88) J,XS,YS,YE,PS,HS
      GO TO 62
61    YPX=WALTAN(J)/XS
      CY=(PS-YS)/XS3
      CI=(PS-YE)/XS3
      IF (J.EQ.2) ICY=1.D+6*(DABS(CY)-DABS(CI))
      IF (MQ.LT.0) GO TO 63
      CYP=(RRC-YPX)/XS/THR
      WRITE (6,88) J,XS,YS,YE,PS,HS,CY,CI,CYP
62    IF (MOD(J,10).EQ.0) WRITE (6,98)
63    WRITE (6,97) ICY
      IF (IQ.GT.0) GO TO 70
      JQ=1
      RETURN
64    LINE=NL
      DO 65 J=1,5
65    WALL(J,NL)=FINAL(J,NP)
C
C     SMOOTH DOWNSTREAM CONTOUR IF DESIRED
      IF (NF.LT.0) CALL NEO
      DO 66 J=1,NL
      WDX(J)=WALL(1,J)
66    WTAN(J)=DTAN(WALL(5,J))
      CALL SCOND (WDX,WTAN,SCDF,NL)
      SCDF(1)=ZRO
      SCDF(NL)=ZRO
      IF (JC.GE.0) GO TO 68
      WRITE (6,104) ITLE
      WRITE (6,99) IFR
      DO 67 K=1,LP,NK
      I=(K-1)/NK+1
      XINCH=SF*CHAR(1,K)+FRIP
      YINCH=SF*CHAR(2,K)
      WRITE (6,103) K,(CHAR(J,K),J=1,6),XINCH,YINCH
67    IF (MOD(I,10).EQ.0) WRITE (6,98)
68    IF (IQ.LT.0) KO=1
      NAG=KO-1
      KING=LINE+NAG
      DO 69 L=1,LINE
      WAX(NAG+L)=WALL(1,L)
      WAY(NAG+L)=WALL(2,L)
      WMN(NAG+L)=WALL(3,L)
      WAN(NAG+L)=CONV*WALL(5,L)
      WALTAN(NAG+L)=WTAN(L)
69    SECD(NAG+L)=SCDF(L)
      IF (MQ.LT.0) GO TO 71
      WRITE (6,94) ITLE
      WRITE (6,84) RC,ETAD,AMACH,BMACH,CMACH,EMACH,MC,AH
      WRITE (6,100) IWL
      WRITE (6,85) (K,WAX(K),WAY(K),WMN(K),WAN(K),WALTAN(K),SECD(K),K=KO
     1,KING)
      GO TO 71
70    KING=KO
C
C     APPLICATION OF SCALE FACTOR TO NON-DIMENSIONAL COORDINATES
71    DO 72 K=1,KING
      S(K)=SF*WAX(K)+FRIP
      FS(K)=SF*WAY(K)
      TTR(K)=ONE+G8*WMN(K)**2
      SPR(K)=ONE/TTR(K)**(ONE+G1)
72    SD(K)=SECD(K)/SF
      IF (ISE.EQ.1) XBIN=ZRO
      IF (ISE.EQ.0) XBIN=XB*SF+FRIP
      XCIN=XC*SF+FRIP
      CALL SCOND (S,WMN,DMDX,KING)
      DMDX(1)=G7*WWOP*WMN(1)**3/WWO**3/SF
      IF (MP.EQ.0 .OR. IQ.LT.0) GO TO 74
      DO 73 K=NUT,KO
73    DMDX(K)=WMN(K)*TTR(K)/(WMN(K)**2-ONE)/QT/SF/WAX(K)
      GO TO 75
74    IF (ISE.EQ.0) DMDX(KO)=AMACH*TTR(KO)/(AMACH**2-ONE)/QT/SF/XA
75    IF (IQ.LT.1 .OR. ISE.EQ.1) DMDX(KING)=ZRO
      DO 76 K=1,KING
76    DPX(K)=-GAM*WMN(K)*DMDX(K)*SPR(K)/TTR(K)
      JQ=0
      KAT=KING
      IF (IABS(MQ).LT.2) GO TO 78
C
C     EXTENSION OF PARALLEL-FLOW CONTOUR
      KIT=KING+1
      KAT=KING+IABS(MQ)
      KUT=S(KING)+HALF
      INC=S(KING)-S(KING-1)
      IF (INC.LT.1) INC=1
      DO 77 K=KIT,KAT
      S(K)=KUT+(K-KING)*INC
      FS(K)=FS(KING)
      WMN(K)=WMN(KING)
      TTR(K)=TTR(KING)
      SPR(K)=SPR(KING)
      WAN(K)=ZRO
      WALTAN(K)=ZRO
      DMDX(K)=ZRO
      DPX(K)=ZRO
77    SD(K)=ZRO
78    IF (XBL.EQ.ZRO) GO TO 79
      IF (S(KING-1).LT.XBL) GO TO 79
C
C     INTERPOLATE FOR VALUES AT SPECIFIED STATION
      CALL TWIXT (S,GMA,GMB,GMC,GMD,XBL,KING,KBL)
      GO TO 80
79    KBL=KAT+4
80    IF (JB.GT.0) RETURN
      IF (ISE.EQ.0) GO TO 81
      WRITE (6,102) ITLE
      WRITE (6,92) RC,SE,XCIN
      GO TO 82
81    IF (IQ.GT.0) WRITE (6,91) ITLE
      IF (IQ.LE.0) WRITE (6,95) ITLE,XBIN,XCIN,SF
      WRITE (6,84) RC,ETAD,AMACH,BMACH,CMACH,EMACH,MC,AH
82    WRITE (6,89)
      WRITE (6,90) (K,S(K),FS(K),WALTAN(K),SD(K),WMN(K),DMDX(K),SPR(K),D
     1PX(K),K=1,KING)
      IF (KBL.GT.KAT) RETURN
      J=KBL-1
      FSX=GMA*FS(J-2)+GMB*FS(J-1)+GMC*FS(J)+GMD*FS(J+1)
      WMNX=GMA*WMN(J-2)+GMB*WMN(J-1)+GMC*WMN(J)+GMD*WMN(J+1)
      DMXX=GMA*DMDX(J-2)+GMB*DMDX(J-1)+GMC*DMDX(J)+GMD*DMDX(J+1)
      DYDX=GMA*WALTAN(J-2)+GMB*WALTAN(J-1)+GMC*WALTAN(J)+GMD*WALTAN(J+1)
      SDX=GMA*SD(J-2)+GMB*SD(J-1)+GMC*SD(J)+GMD*SD(J+1)
      SPRX=GMA*SPR(J-2)+GMB*SPR(J-1)+GMC*SPR(J)+GMD*SPR(J+1)
      DPXX=GMA*DPX(J-2)+GMB*DPX(J-1)+GMC*DPX(J)+GMD*DPX(J+1)
      WRITE (6,101) XBL,FSX,DYDX,SDX,WMNX,DMXX,SPRX,DPXX
      RETURN
83    WRITE (6,86) IP,NN,LINE,J
      RETURN
C
84    FORMAT (1H ,4H RC=,F11.6,3X,5HETAD=F8.4,4H DEG,3X,6HAMACH=F10.7,3X
     1,6HBMACH=F10.7,3X,6HCMACH=F10.7,3X,6HEMACH=F10.7,3X,A4,2HH=F11.7/)
85    FORMAT (10(8X,I3,2X,1P6E15.7/))
86    FORMAT (1H0,9HOFELD,IP=,I3,5H, NN=,I3,7H, LINE=,I3,8H, POINT=,I3 )
87    FORMAT (1H ,9X,    'POINT X/YO',8X,'Y/YO',7X,'INT.Y/YO',7X,'PAR/YO
     1',7X,'HYP/YO       C(Y)',11X,'C(YI)',10X,'C(YP)' /)
88    FORMAT (1H ,9X,I3,5F13.7,1P3E15.6 )
89    FORMAT (1H ,9X,5HPOINT,7X,5HX(IN),9X,5HY(IN),9X,5HDY/DX,8X,7HD2Y/D
     1X2,7X,8HMACH NO.,7X,5HDM/DX,9X,5HPE/PO,11X,6HDPR/DX/)
90    FORMAT (10(10X,I3,2X,0P6F14.7,1P2E16.5/))
91    FORMAT (1H1,3A4,17H UPSTREAM CONTOUR/)
92    FORMAT (1H ,' RC=',F11.7,',     STREAMLINE RATIO=',F11.8,',   TEST
     1 CONE BEGINS AT',F12.7,' IN.' / )
93    FORMAT (1H1,3A4,22H THROAT CHARACTERISTIC )
94    FORMAT (1H1,3A4,19H DOWNSTREAM CONTOUR/)
95    FORMAT (1H1,3A4,45H INVISCID NOZZLE CONTOUR, RADIAL FLOW ENDS ATF1
     11.6,25H IN., TEST CONE BEGINS ATF11.6,19H IN., SCALE FACTOR=F9.4/)
96    FORMAT (1H0,8X,6HMASS =,F13.10)
97    FORMAT (1H0,9X,5HICY =, I13 / )
98    FORMAT (1H )
99    FORMAT (1H ,8X,A4/8X,5HPOINT,8X,1HX,14X,1HY,10X,68HMACH NO.      M
     1ACH ANG.(D)     PSI (D)     FLOW ANG.(D)CDI     X(IN),9X,5HY(IN)/)
100   FORMAT (1H ,8X,A4/8X,5HPOINT,8X,1HX,14X,1HY,10X,37HMACH NO.      F
     1LOW ANG.(D)     WALTAN,9X,6HSECDIF/)
101   FORMAT (1H0,14X,6F14.7,1P2E16.5)
102   FORMAT (1H1,3A4,17H INVISCID CONTOUR/)
103   FORMAT (1H ,I10,2X,1P6E15.7,0P2F14.7)
104   FORMAT (1H1,3A4,33H INTERMEDIATE LEFT CHARACTERISTIC/)
105   FORMAT (1H1,3A4,34H INTERMEDIATE RIGHT CHARACTERISTIC /)
106   FORMAT (1H ,8H CHARACT,I4/8X,5HPOINT,8X,1HX,14X,1HY,10X,68HMACH NO
     1.     MACH ANG.(D)      PSI (D)      FLOW ANG.(D)       X(IN),9X,5
     2HY(IN) /)
107   FORMAT (1H0,12H   CONTOUR  ,1P3E15.7 )
      END