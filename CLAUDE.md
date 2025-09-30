# claude-shuttle

목적 

    이 리포지토리는 tmux 안에서 Neovim을 사용하며, 간단한 명령으로 Claude CLI를 옆/아래로 열고 선택한 코드 블록을 경로+라인 정보와 함께 Claude로 보낼 수 있게 하는 플러그인을 제공합니다.
    기본 가정: Neovim은 항상 tmux 세션 내부에서 실행됩니다.
     

요구 사항 

    tmux 3.2 이상 (send-keys, load-buffer, paste-buffer 사용)
    Neovim 0.8 이상
    Claude용 CLI 커맨드
        예: anthropic CLI의 대화형 모드(anthropic interact), 혹은 사용자가 제공하는 claude 실행 스크립트
        본 플러그인은 실행 커맨드를 설정값으로 받습니다. 특정 CLI에 종속되지 않습니다.
         
    환경변수 TMUX가 설정되어 있어야 합니다 (tmux 내부에서 실행)
     

핵심 기능 

    :Claudev
        현재 tmux pane을 기준으로 vertical split을 생성해 Claude CLI를 실행합니다.
         
    :Claudeh
        현재 tmux pane을 기준으로 horizontal split을 생성해 Claude CLI를 실행합니다.
         
    :'<,'>Claudev, :'<,'>Claudeh
        Visual 모드에서 선택한 라인의 범위를 받아, 새로 연 Claude pane으로 코드 블록을 경로+라인 앵커와 함께 전송합니다.
        경로 포맷은 Neovim을 실행한 최초 작업 디렉토리 기준의 상대경로를 사용합니다.
        앵커 포맷은 다음과 같습니다.
            단일 라인: @path/to/file#L10
            범위: @path/to/file#L10-25
             
        코드 블록은 가능하면 파일타입을 언어 펜스에 반영합니다. (예: ```python)
         

