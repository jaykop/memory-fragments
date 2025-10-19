# Chapter 5: Rooftop
VAR trust = 50

차갑고 축축한 감촉. 천천히 눈을 뜬다.

* [주변을 둘러본다]
    폐건물 옥상. 콘크리트 바닥. 손에는...
    ** [손을 본다]
        피 묻은 권총이 쥐어져 있다.
        *** [발치를 본다]
            쓰러진 누군가. 얼굴은 알아볼 수 없다.
            ~ trust = trust - 10
            -> sirens
            
* [일어서려 한다]
    머리가 지끈거린다. 몸을 일으키기 힘들다.
    ** [억지로 일어난다]
        주변을 둘러본다. 폐건물 옥상이다.
        ~ trust = trust + 5
        -> sirens

=== sirens ===
저 멀리서 사이렌 소리가 들린다.

* [도망친다]
    # CLUE_FOUND: escaped_rooftop
    서둘러 계단으로 향한다.
    -> END
    
* [그 자리에 선다]
    # CLUE_FOUND: stayed_rooftop
    어차피 도망칠 수 없다.
    -> END
