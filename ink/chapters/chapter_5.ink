=== chapter_5 ===

// Chapter 5: The Last Witness
// Time: 2024.11.15, 23:00
// Location: Abandoned Building Rooftop

~ chapter_name = "마지막 목격자"
~ current_location = "rooftop_night"
~ play_bgm("tension_ambient")

-> awakening

=== awakening ===

# NARRATION
추웠다.

콘크리트 바닥이 등짝을 파고든다. 
입안이 바싹 마르고, 왼쪽 관자놀이가 욱신거린다.

# THOUGHT
어디지.

# NARRATION
눈을 뜨니 하늘이 보인다. 구름 낀 밤하늘.
고개를 돌리자 뭔가 손에 잡힌다. 차갑고 무거운.

권총.

손잡이에 피가 묻어있다.

일어나 앉으려는데 발에 뭔가 걸렸다.
...사람이다.

엎드려 있다. 움직이지 않는다.
뒤통수에서 검붉은 게 흘러나와 바닥을 적시고 있다.

# AUTO_PROCEED
뒤로 물러난다. 손에서 권총을 놓쳤다.
떨어지는 소리가 유난히 크게 들린다.

# THOUGHT
어떻게 된 거지.
왜 여기 있지.
저 사람은 누구지.

# NARRATION
기억이.

기억이 안 난다.

~ unlock_clue("scene_intro")

-> radio_call

=== radio_call ===

# SFX: radio_static

# CHARACTER: minsoo | worried
준혁아.

# CHARACTER: minsoo | worried
나야, 민수.

# THOUGHT
민수?

# CHARACTER: minsoo | worried
...거기 있는 거 알아. 응답 좀 해봐.

# CHARACTER: junhyuk | confused
어, 민수 형?

# CHARACTER: minsoo | shocked
...아, 씨발. 진짜네.

# PAUSE: 1.5

# CHARACTER: minsoo | tense
지금 어디야. 안 다쳤어?

# CHARACTER: junhyuk | confused
다치진... 근데 형, 나 지금...

# THOUGHT
뭐라고 해야 하지.

# CHARACTER: junhyuk | uncertain
여기 사람이 쓰러져 있는데. 죽은 것 같아.

# CHARACTER: minsoo | serious
...알고 있어.

# CHARACTER: junhyuk | shocked
뭐?

# CHARACTER: minsoo | serious
네가 신고한 거 아니야. 익명 제보 들어왔거든.

# THOUGHT
신고?

# CHARACTER: junhyuk | confused
아니, 나 기억이 안 나서...

# CHARACTER: minsoo | concerned
뭐가?

# CHARACTER: junhyuk | desperate
전부. 왜 여기 왔는지도 모르겠고, 저 사람이 누군지도...

# CHARACTER: minsoo | grave
준혁아.

# PAUSE: 0.8

# CHARACTER: minsoo | grave
지금 그 자리에서 한 발자국도 움직이지 마. 알았지?

# CHARACTER: junhyuk | confused
...예?

# CHARACTER: minsoo | urgent
5분. 내가 5분 안에 간다. 그때까지 아무 것도 만지지 말고.

# CHARACTER: junhyuk | desperate
형, 뭔 소리...

# CHARACTER: minsoo | pleading
준혁아, 제발.

# PAUSE: 0.5

# CHARACTER: minsoo | trembling
넌... 넌 그런 놈 아니잖아. 그러니까 그냥 기다려.

# SFX: radio_disconnect

# NARRATION
통신이 끊겼다.

# THOUGHT
그런 놈?

~ unlock_clue("radio_minsoo")

-> investigation

=== investigation ===

# NARRATION
머리가 개운치 않지만, 가만히 있을 수만은 없다.
형사 본능이랄까. 몸이 먼저 움직인다.

# INVESTIGATION_MODE
// Player can click on clues

+ [시체를 조사한다] -> examine_corpse
+ [권총을 조사한다] -> examine_gun
+ [CCTV를 조사한다] -> examine_cctv
+ [쪽지를 발견한다] -> examine_note

= examine_corpse
# NARRATION
다가가긴 싫은데.
발걸음을 옮긴다.

30대 후반? 정장 차림.
오른손에 뭔가 쥐어져 있다.
명함.

# CLUE_FOUND: business_card
「정태호 / 법무법인 혜윤 / 변호사」

# THOUGHT
변호사.
아는 사람인가?

~ unlock_clue("corpse_lawyer")
-> investigation

= examine_gun
# NARRATION
바닥에 떨어진 권총을 집어든다.
경찰 제식 권총. 발사 흔적이 있다.

총번이 찍혀있다.
# CLUE_FOUND: gun_serial
「SPD-342-1129」

# THOUGHT
내 총이다.

~ unlock_clue("gun_bloody")
-> investigation

= examine_cctv
# NARRATION
구석에 CCTV가 있다.
렌즈가 깨져있다. 누가 부순 것 같다.

케이블도 뽑혀있다. 계획적이네.

~ unlock_clue("cctv_broken")
-> investigation

= examine_note
# NARRATION
옥상 난간 모서리에 쪽지가 붙어있다.
바람에 펄럭인다.

종이를 떼어 펼친다.

# CLUE_FOUND: cryptic_note
「기억을 믿지 마」

# THOUGHT
...뭔 소리야.

# NARRATION
아래 작은 글씨로 더 쓰여있다.

# CLUE_DETAIL
「20241115-2100-Factory」

# THOUGHT
오늘 날짜. 9시. 공장?

~ unlock_clue("note_cryptic")
-> investigation

- [조사를 마친다] -> sirens

=== sirens ===

# SFX: police_sirens_distant

# NARRATION
멀리서 사이렌 소리가 들린다.

예상보다 빠르다.
3분도 안 걸렸나.

# CHOICE_POINT
* [그대로 기다린다] -> wait_choice
* [증거를 더 확보한다] -> gather_evidence
* [여기서 빠져나간다] -> escape_choice

= wait_choice
# NARRATION
움직이지 않기로 한다.
민수 형이 뭔가 알고 있는 것 같다.

1분.
2분.

# SFX: door_burst

# NARRATION
옥상 문이 벌컥 열린다.

# CHARACTER: swat_officer | aggressive
손 들어! 움직이지 마!

# NARRATION
3명. 완전무장.
총구가 이쪽을 향한다.

# CHARACTER: swat_officer | aggressive
바닥에 엎드려!

# CHARACTER: junhyuk | panicked
잠깐, 나 이준혁 형사...

# CHARACTER: swat_officer | aggressive
닥치고 엎드리라고!

# SFX: running_footsteps

# CHARACTER: minsoo | urgent
야! 진정해!

# NARRATION
민수 형이다. 숨이 차서 헐떡인다.

# CHARACTER: minsoo | urgent
준혁이 너, 이 새끼가 아니야. 총 내려!

# CHARACTER: swat_officer | uncertain
형사님, 하지만 현장에서...

# CHARACTER: minsoo | firm
내가 책임진다니까!

# NARRATION
민수 형이 다가온다.
손을 뻗는다.

# CHARACTER: minsoo | concerned
...괜찮아?

# NARRATION
고개를 끄덕였다.

# CHARACTER: junhyuk | desperate
형, 나...

# CHARACTER: minsoo | serious
아무 말 하지 마. 지금은.

# NARRATION
그의 눈빛이 복잡하다.

~ trust_change(5)
~ choice_made("wait")

-> memory_connection

= gather_evidence
# NARRATION
일단 내 폰부터.

잠금을 풀고 통화 기록을 확인한다.

# CLUE_FOUND: phone_log
마지막 통화: 오늘 밤 10시 47분
상대방: 발신자 표시 제한

13분 전이다.
통화 시간 2분 17초.

# THOUGHT
누구랑 통화했지?

# NARRATION
문자는... 전부 지워져있다.
오늘 것만 싹 다.

# SFX: police_sirens_close

# NARRATION
사이렌 소리가 가까워진다.

아래층에서 발소리.
계단을 오르고 있다.

# THOUGHT
시간이 없다.

~ unlock_clue("deleted_messages")
~ trust_change(3)
~ choice_made("investigate")

-> wait_choice.swat_officer

= escape_choice
# NARRATION
본능이 말한다. 도망쳐.

옥상 반대편으로 뛴다.
비상 계단이 있다.

뒤돌아보니 경찰차 불빛이 보인다.
3대. 아니 4대.

# THOUGHT
과잉 대응 아닌가.

# NARRATION
계단을 내려간다. 3층, 2층.

# CHARACTER: officer_voice | aggressive
거기 서!

# NARRATION
위에서 외치는 소리.

1층 출구로 뛰어나간다.

골목. 어둡다.

# THOUGHT
어디로 가야 하지.

# SFX: running_footsteps

# NARRATION
뒤에서 발소리. 많다.

# CHARACTER: officer_voice | aggressive
이준혁! 멈춰!

# THOUGHT
모르는 목소리다.

# CHASE_SEQUENCE
// Chase minigame or cutscene

# NARRATION
[체포됨]

~ trust_change(-15)
~ choice_made("escape")

-> memory_connection

=== memory_connection ===

# CHAPTER_END
# DEDUCTION_MODE

// Memory Connection Board Phase

# NARRATION
획득한 단서들이 보드에 펼쳐진다.

# CLUES_DISPLAY
• 피 묻은 권총 (내 총)
• 시체 - 정태호 변호사
• 쪽지 "기억을 믿지 마"
• 암호 같은 숫자 "20241115-2100"
• 삭제된 통화 기록
• 파손된 CCTV

# DEDUCTION_PUZZLE
Q: 가장 먼저 일어난 일은?

+ [A) 권총 발사] -> wrong_answer
+ [B) CCTV 파손] -> correct_answer
+ [C) 통화 기록 삭제] -> wrong_answer

= wrong_answer
# FEEDBACK
아니다. 다시 생각해보자.

~ trust_change(-3)
-> memory_connection.DEDUCTION_PUZZLE

= correct_answer
# FEEDBACK: correct
누군가 이 일을 계획했다.
그리고 증거를 지웠다.

하지만 쪽지는 남겼다.

"20241115-2100"

오늘. 오후 9시.

# THOUGHT
...그 시간에 뭐가 있었지?

~ trust_change(5)

-> flashback

=== flashback ===

# VISUAL_EFFECT: screen_distortion
# SFX: memory_glitch

# NARRATION
어둠.
공장 같은 곳.
녹슨 철문.

# CHARACTER: unknown_male_1 | threatening
준혁, 혼자 오면 끝이야.

# THOUGHT
남자 목소리. 누구지.

# CHARACTER: unknown_male_2 | mocking
그 새끼 혼자 못 와. 걱정 마.

# THOUGHT
다른 목소리. 더 젊다.

# CHARACTER: junhyuk | tense
...거래하자. 내가 원하는 게 뭔지 알잖아.

# SCREEN_FADE: black

# CHAPTER_TRANSITION
『2시간 전』
『11월 15일 오후 9시』
『폐공장』

-> END

=== function unlock_clue(clue_id) ===
// Call to Godot: emit_signal("clue_unlocked", clue_id)
~ return

=== function trust_change(amount) ===
// Call to Godot: emit_signal("trust_changed", amount)
~ return

=== function choice_made(choice_id) ===
// Call to Godot: emit_signal("choice_recorded", choice_id)
~ return

=== function play_bgm(track_name) ===
// Call to Godot: emit_signal("play_bgm", track_name)
~ return
