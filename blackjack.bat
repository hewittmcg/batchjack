@echo off
title BLACKJACK 1-ON-1
echo BLACKJACK V3.3.1
:restart
echo Press any key to play.
pause>null
@set /a pmny=50
@set /a dmny=60
:ante
echo How much do you want to ante each hand (ante must be between
echo 1 and 10)?
@set /p ante=
if %ante% GTR 10 (goto bigante) 
if %ante% LSS 1 (goto smlante) else (goto newhand)
:bigante
echo That ante's too big!
goto ante
:smlante
echo That ante's too small!
goto ante
:newhand
cls
@set /a pot=0
echo You have $%pmny%.
echo The dealer has $%dmny%.
timeout /t 2 /nobreak>null
cls
echo Ante Up!
@set /a pmny=%pmny%-%ante%
@set /a dmny=%dmny%-%ante%
if %pmny% LEQ 0 (goto pbroke)
if %dmny% LEQ 0 (goto dbroke)
echo You ante $%ante%.
@set /a pot=%ante%*2
echo The pot contains $%pot%, whoever wins gets the pot!
timeout /t 2 /nobreak>null 
@set /a crdcount=0
@set /a ct=0
@set /a dubscor=0
cls
:deal
echo Dealing card(s)...
:2deal
@set /a curcard=%random% %% 13 + 1
@set /a crdcount=%crdcount%+1
if %curcard%==0 (goto 2deal)
if %curcard%==-1 (goto 2deal)
if %curcard%==1 (set curcard=Ace)
if %curcard%==11 (set curcard=Jack)
if %curcard%==12 (set curcard=Queen)
if %curcard%==13 (set curcard=King)
timeout /t 1 /nobreak>null
echo Your card is a %curcard%.
if %curcard%==Ace (set curcard=1)
if %curcard%==Jack (set curcard=10)
if %curcard%==Queen (set curcard=10)
if %curcard%==King (set curcard=10)
@set /a ct=%ct%+%curcard%
if %curcard%==1 (set /a dubscor=%ct%+10)
if %dubscor%== GTR 21 (set dubscor=0)
echo Your total is %ct%/%dubscor%. 
if %ct% GEQ 22 (goto bust)
if %ct%==21 (goto 21)
if %dubscor%==21 (goto 21)
timeout /t 2 /nobreak>null
if %crdcount%==1 (goto 2deal) else (goto hs)
:hs
choice /n /C:hs /m "H=Hit, S=Stick (h or s)"%!
if %errorlevel%==1 (goto deal) else (goto stick)
pause
:bust 
echo You busted!
goto dwin
:stick
echo You sticked!
if %dubscor%== GTR %ct% (set ct=%dubscor%)
echo Right now, your score is %ct%.
echo It's the dealer's turn to get cards!
echo Dealing dealer's card(s)...
:ddeal
@set /a dcrdcount=0
@set /a dct=0
@set /a ddubscor=0
:2ddeal
@set /a dcurcard=%random% %% 13+1
@set /a dcrdcount=%dcrdcount%+1
if %dcurcard%==0 (goto 2ddeal)
if %dcurcard%==-1 (goto 2ddeal)
if %dcurcard%==1 (set dcurcard=Ace)
if %dcurcard%==11 (set dcurcard=Jack)
if %dcurcard%==12 (set dcurcard=Queen)
if %dcurcard%==13 (set dcurcard=King)
timeout /t 1 /nobreak>null
echo The dealer's card is a %dcurcard%.
if %dcurcard%==Ace (set dcurcard=1)
if %dcurcard%==Jack (set dcurcard=10)
if %dcurcard%==Queen (set dcurcard=10)
if %dcurcard%==King (set dcurcard=10)
@set /a dct=%dct%+%dcurcard%
if %dcurcard%==1 (set /a ddubscor=%ct%+10)
if %ddubscor%== GTR 21 (set ddubscor=0)
echo The dealer's total score is %dct%/%ddubscor%.
if %dct% GEQ 22 (goto pwin)
if %dct%==21 (goto dwin)
if %ddubscor%==21 (goto dwin)
timeout /t 2 /nobreak>null
if %dcrdcount%==1 (goto 2ddeal) else (goto dhs)
:dhs
if %dct% LEQ 16 (goto 2ddeal) else (goto compare)
:compare 
if %ddubscor%== GTR %dct% (set dct=%ddubscor)
echo The dealer stuck at his score, %dct%!
echo Your score is %ct%!
if %ct% GTR %dct% (goto pwin) else (goto dwin)
:pwin
echo You won, so you get the pot!
@set /a pmny=%pmny%+%pot%
echo Press any key to deal the next hand!
pause>null
goto newhand
:dwin
echo The dealer beat you, and he gets the pot!
@set /a dmny=%dmny%+%pot%
echo Press any key to deal another hand.
pause>null
goto newhand
:21
echo You got 21!  Good job!
echo The dealer will either get 21 and beat you, or bust!
echo Dealing dealer's card(s)...
@set /a dcrdcount=0
@set /a dct=0
:redeal
@set /a dcurcard=%random% %% 13-1
@set /a dcrdcount=%dcrdcount%+1
if %dcurcard%==0 (goto redeal)
if %dcurcard%==-1 (goto redeal)
if %dcurcard%==1 (@set /a dcurcard=Ace)
if %dcurcard%==11 (@set /a dcurcard=Jack)
if %dcurcard%==12 (@set /a dcurcard=Queen)
if %dcurcard%==13 (@set /a dcurcard=King)
@set /a dct=%dct%+%dcurcard%
timeout /t 1 /nobreak>null
echo The dealer's card is a %dcurcard%.
echo The dealer's total score is %dct%.
if %dct% GEQ 22 (goto pwin21)
if %dct%==21 (goto dwin21)
if %dct% LSS 21 (goto redeal)
:pwin21
echo The dealer busted trying to get 21!
echo Therefore, you win the pot!
@set /a pmny=%pmny%+%pot%
echo Press any key to play another hand!
pause>null
goto newhand
:dwin21
echo The dealer got 21, and so beats your 21 since tie goes to the dealer.
echo He wins the pot.
@set /a dmny=%dmny%+%pot%
echo Press any key to play another hand.
pause>null
goto newhand 
:pbroke
echo You lost all your money!
choice /n /C:yn /m "(Play again? (y or n)"%1
if %errorlevel%==1 (goto restart) else (goto end)
:dbroke
echo You took all the dealer's money!
choice /n /C:yn /m "Play again? (y or n)"%1
if %errorlevel%==1 (goto restart) else (goto end)
:end
echo Ending program in 3...
timeout /t 1 /nobreak>null
cls
echo Ending program in 2...
timeout /t 1 /nobreak>null
cls
echo Ending program in 1...
timeout /t 1 /nobreak>null
cls 
echo Ending program.
timeout /t 0.5 /nobreak>null