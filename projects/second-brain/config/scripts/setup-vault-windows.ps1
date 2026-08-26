# setup-vault-windows.ps1 — 비개발자용 vault 온보딩 스크립트 (Windows 10 1809+)
# origin: lemoncloud-io/knowledge@3b6a3d9:projects/second-brain/config/scripts/setup-vault-windows.ps1
#
# 하는 일:
#   1. Git·Obsidian·Claude Code CLI·GitHub CLI·문서 변환 도구(pandoc·uv)가 없으면 설치
#      (winget + 공식 설치기). 변환 도구는 -SkipConverters 로 건너뛸 수 있다
#   2. GitHub 브라우저 로그인(gh auth login) + git 사용자 정보(이름·이메일) 설정
#   3. 팀 vault repo URL을 물어 clone (기본 경로: $HOME\knowledge)
#   4. VAULT_DIR 사용자 환경변수 등록
#   5. 구조·심링크 검증 후 다음 단계 안내
#
# 사용법 — git이 없어도 됨. PowerShell에 아래 한 줄만 붙여넣으면 끝
# (파일 다운로드·실행 정책 설정 불필요):
#   & ([scriptblock]::Create((irm https://raw.githubusercontent.com/lemoncloud-io/2nd-brain/master/projects/second-brain/config/scripts/setup-vault-windows.ps1).TrimStart([char]0xFEFF)))
#   (이 파일은 Windows PowerShell 5.1의 파일 실행 시 한글 깨짐을 막으려 UTF-8 BOM을
#    달고 있다. irm은 BOM을 그대로 문자열에 넘겨 PowerShell 7의 파서가 실패하므로
#    TrimStart로 벗긴다 — BOM이 이미 없으면 무해한 no-op이다.)
#
# repo/경로를 미리 지정하려면 인자를 붙인다:
#   & ([scriptblock]::Create((irm ...).TrimStart([char]0xFEFF))) -RepoUrl https://github.com/<org>/<repo>.git -TargetDir "$HOME\my-vault"
# 파일로 받아 실행할 때:
#   Set-ExecutionPolicy -Scope Process Bypass -Force
#   .\setup-vault-windows.ps1 [-RepoUrl <url>] [-TargetDir <경로>] [-SkipConverters]
#
# 필요 선행 조건: winget(Windows 10/11 기본 내장 '앱 설치 관리자') — 없으면 안내 후 중단
# 재실행해도 안전하다(이미 설치/클론/설정된 항목은 건너뜀).
#
# 기본 RepoUrl은 공개 부트스트랩 템플릿이다. 실제 clone 대상은 5번 단계에서 팀 repo
# URL을 물어 결정한다 — 조직 값의 단일 출처는 projects/second-brain/config/team-settings.yaml.
param(
    [string]$RepoUrl   = "https://github.com/lemoncloud-io/2nd-brain.git",
    [string]$TargetDir = "$HOME\knowledge",
    [switch]$SkipConverters
)
$ErrorActionPreference = "Stop"
$TemplateUrl = "https://github.com/lemoncloud-io/2nd-brain.git"

function Say($msg)  { Write-Host "`n==> $msg" -ForegroundColor Green }
function Warn($msg) { Write-Host "`n[주의] $msg" -ForegroundColor Yellow }
function Fail($msg) { Write-Host "`n[실패] $msg" -ForegroundColor Red; exit 1 }
# URL 비교용 정규화: 프로토콜·ssh 접두·.git 접미를 벗겨 host/org/repo만 남긴다
function Get-NormalizedRepoUrl($u) {
    (($u -replace '^https?://','' -replace '^git@','' -replace ':','/' -replace '\.git$','').TrimEnd('/'))
}

# ── 0. winget 확인 ───────────────────────────────────────────
if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Fail "winget이 없습니다. Microsoft Store에서 '앱 설치 관리자(App Installer)'를 설치한 뒤 재실행하세요."
}
function Update-SessionPath {
    $env:Path = [Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [Environment]::GetEnvironmentVariable("Path","User")
}

# ── 1. Git ───────────────────────────────────────────────────
if (Get-Command git -ErrorAction SilentlyContinue) {
    Say "Git 확인됨: $(git --version)"
} else {
    Say "Git 설치 중..."
    winget install --id Git.Git -e --accept-source-agreements --accept-package-agreements
    Update-SessionPath
    if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
        Fail "Git을 설치했지만 git 명령을 아직 찾지 못합니다. 새 PowerShell 창을 열어 이 스크립트를 다시 실행하세요."
    }
}

# ── 2. Obsidian ──────────────────────────────────────────────
$obsidianInstalled = winget list --id Obsidian.Obsidian -e 2>$null | Select-String "Obsidian"
if ($obsidianInstalled) {
    Say "Obsidian 확인됨"
} else {
    Say "Obsidian 설치 중..."
    winget install --id Obsidian.Obsidian -e --accept-source-agreements --accept-package-agreements
}

# ── 3. Claude Code CLI (공식 설치기 — 자동 업데이트됨) ──────
if (Get-Command claude -ErrorAction SilentlyContinue) {
    Say "Claude Code 확인됨"
} else {
    Say "Claude Code 설치 중..."
    irm https://claude.ai/install.ps1 | iex
    $env:Path += ";$HOME\.local\bin"
    if (-not (Get-Command claude -ErrorAction SilentlyContinue)) {
        Warn "claude 명령을 아직 찾지 못했습니다 — 설치는 됐을 수 있으니 새 PowerShell에서 'claude --version'으로 확인하세요."
    }
}

# ── 3b. 문서 변환 도구 (pandoc · uv) ─────────────────────────
# hwp·doc·pdf를 위키에 넣는 변환 스킬(hwp2md·doc2md·pdf2md-ingest)의 공통 전제.
# 웹 클리핑만 쓰는 구성원은 -SkipConverters 로 건너뛴다. 실패해도 온보딩은 계속된다.
if ($SkipConverters) {
    Say "문서 변환 도구 설치 건너뜀 (-SkipConverters)"
} else {
    foreach ($tool in @(@{ cmd = "pandoc"; id = "JohnMacFarlane.Pandoc" }, @{ cmd = "uv"; id = "astral-sh.uv" })) {
        if (Get-Command $tool.cmd -ErrorAction SilentlyContinue) {
            Say "$($tool.cmd) 확인됨"
        } else {
            Say "$($tool.cmd) 설치 중 (hwp·doc·pdf 변환용)..."
            winget install --id $tool.id -e --accept-source-agreements --accept-package-agreements
            Update-SessionPath
            if (-not (Get-Command $tool.cmd -ErrorAction SilentlyContinue)) {
                Warn "$($tool.cmd) 명령을 아직 찾지 못했습니다 — 새 PowerShell에서 '$($tool.cmd) --version'으로 확인하세요. (hwp·doc·pdf 변환에만 필요, 온보딩은 계속됩니다)"
            }
        }
    }
}

# ── 4. GitHub 로그인 + git 사용자 정보 ───────────────────────
# 프라이빗 팀 repo clone과 이후 커밋·PR(Claude 위임 포함)에 필요하다.
if (-not (Get-Command gh -ErrorAction SilentlyContinue)) {
    Say "GitHub CLI 설치 중..."
    winget install --id GitHub.cli -e --accept-source-agreements --accept-package-agreements
    Update-SessionPath
    if (-not (Get-Command gh -ErrorAction SilentlyContinue)) {
        Fail "GitHub CLI를 설치했지만 gh 명령을 아직 찾지 못합니다. 새 PowerShell 창을 열어 이 스크립트를 다시 실행하세요."
    }
}
gh auth status 2>$null | Out-Null
if ($LASTEXITCODE -eq 0) {
    Say "GitHub 로그인 확인됨"
} else {
    Say "GitHub 로그인 — 브라우저가 열리면 안내를 따르세요"
    gh auth login --web --git-protocol https
    if ($LASTEXITCODE -ne 0) { Fail "GitHub 로그인 실패 — 재실행하세요." }
}
gh auth setup-git 2>$null   # HTTPS clone/push에 gh 자격증명 사용

if (-not (git config --global user.name 2>$null)) {
    $gitName = Read-Host "git 커밋에 기록할 이름 (예: 홍길동)"
    if ($gitName) { git config --global user.name $gitName }
}
if (-not (git config --global user.email 2>$null)) {
    $gitEmail = Read-Host "git 커밋에 기록할 이메일 (회사 이메일)"
    if ($gitEmail) { git config --global user.email $gitEmail }
}
if (-not (git config --global user.name 2>$null) -or -not (git config --global user.email 2>$null)) {
    Warn "git 사용자 정보 미설정 — 커밋 시 필요합니다:`n  git config --global user.name `"이름`" ; git config --global user.email `"이메일`""
}

# ── 5. 팀 repo 지정 + vault clone ────────────────────────────
if (-not (Test-Path (Join-Path $TargetDir ".git")) -and ($RepoUrl -eq $TemplateUrl)) {
    $inputUrl = Read-Host "팀 vault repo URL을 입력하세요 (예: https://github.com/<org>/<repo>.git — 엔터 = 공개 템플릿으로 시작)"
    if ($inputUrl) { $RepoUrl = $inputUrl }
    if ($RepoUrl -eq $TemplateUrl) {
        Warn "공개 템플릿($TemplateUrl)을 clone합니다 — 팀 위키가 아닙니다.`n팀 repo가 있다면 지금 중단(Ctrl+C)하고 재실행 때 URL을 입력하세요.`n팀 repo를 새로 만들 관리자는 clone 대신 GitHub template 생성이 정본입니다:`n  docs/wiki-vault-setup-free.md 참조 (gh repo create --template lemoncloud-io/2nd-brain --private)"
    }
}

if (Test-Path (Join-Path $TargetDir ".git")) {
    Say "vault가 이미 있습니다: $TargetDir (clone 생략)"
} elseif ((Test-Path $TargetDir) -and (Get-ChildItem $TargetDir -Force -ErrorAction SilentlyContinue | Select-Object -First 1)) {
    Fail "$TargetDir 폴더가 이미 있고 비어있지 않은데 git repo가 아닙니다. 폴더를 비우거나 -TargetDir로 다른 경로를 지정해 재실행하세요."
} else {
    Say "vault clone 중: $RepoUrl → $TargetDir"
    # core.symlinks=true: .claude/skills 상대 심링크 보존 시도 (검증은 7번 단계)
    git clone -c core.symlinks=true $RepoUrl $TargetDir
    if ($LASTEXITCODE -ne 0) {
        Fail "clone 실패 — repo 주소와 팀 repo 초대 수락 여부를 확인하세요. 로그인 문제라면 'gh auth login'으로 브라우저 로그인 후 재실행하세요."
    }
}

# 잔여 안전망: origin이 여전히 공개 템플릿이면 push·PR이 공개 repo로 향한다
$currentOrigin = git -C $TargetDir remote get-url origin 2>$null
if ($currentOrigin -and ((Get-NormalizedRepoUrl $currentOrigin) -eq (Get-NormalizedRepoUrl $TemplateUrl))) {
    Warn "origin이 공개 부트스트랩 템플릿입니다. 팀 repo가 생기면 전환하세요:`n  git -C `"$TargetDir`" remote set-url origin <팀-repo-URL>"
}

# ── 6. VAULT_DIR 등록 ────────────────────────────────────────
$existingVaultDir = [Environment]::GetEnvironmentVariable("VAULT_DIR", "User")
if (-not $existingVaultDir) {
    [Environment]::SetEnvironmentVariable("VAULT_DIR", $TargetDir, "User")
    Say "VAULT_DIR 사용자 환경변수 등록됨: $TargetDir"
} elseif ($existingVaultDir -eq $TargetDir) {
    Say "VAULT_DIR 이미 등록됨: $TargetDir"
} else {
    Warn "VAULT_DIR이 다른 경로로 이미 등록되어 있습니다: $existingVaultDir`n이번 설치 경로($TargetDir)를 쓰려면 시스템 설정 → 환경 변수에서 VAULT_DIR을 수정하세요."
}

# ── 7. 구조 검증 ─────────────────────────────────────────────
if (-not (Test-Path (Join-Path $TargetDir "VAULT_RULES.md"))) {
    Fail "VAULT_RULES.md가 없습니다 — repo 주소를 확인하세요."
}
if (-not (Test-Path (Join-Path $TargetDir "wiki"))) {
    Warn "wiki/ 폴더가 없습니다 — vault 구조를 확인하세요."
}
# 심링크 검증: git 인덱스 기준 symlink(mode 120000)가 디스크에서 ReparsePoint가 아니면
# Developer Mode 꺼진 체크아웃 — .claude/skills가 텍스트 파일로 떨어져 스킬이 동작하지 않는다.
$symlinkPaths = @(git -C $TargetDir ls-files -s | Select-String '^120000' | ForEach-Object { ($_.Line -split "`t")[-1] })
$brokenLinks = @($symlinkPaths | Where-Object {
    $item = Get-Item (Join-Path $TargetDir $_) -Force -ErrorAction SilentlyContinue
    -not ($item -and ($item.Attributes -band [IO.FileAttributes]::ReparsePoint))
})
if ($brokenLinks.Count -gt 0) {
    Warn "심링크 $($brokenLinks.Count)개가 텍스트 파일로 체크아웃됐습니다 (예: $($brokenLinks[0])).`n.claude/skills가 동작하지 않습니다. Windows 설정 → 개발자 모드(Developer Mode)를 켠 뒤:`n  git -C `"$TargetDir`" checkout -- .`n으로 다시 체크아웃하거나 폴더를 지우고 재실행하세요."
} else {
    Say "구조 검증 통과"
}

# ── 8. 다음 단계 안내 ────────────────────────────────────────
Write-Host @"

────────────────────────────────────────────
설치 완료! 다음 단계:

 0. (팀 repo를 처음 만드는 관리자만) projects/second-brain/config/team-settings.yaml을
    팀 값으로 교체 — vault.name · github.vault_repo · github.default_reviewer 등
    (docs/knowledge-wiki-setup-guide.md § 3 참조)
 1. Obsidian 실행 → "Open folder as vault" → 방금 만든 vault 폴더 선택
 2. Obsidian Settings → Community plugins → Restricted mode 끄기
    권장 플러그인: Git, Templater, Dataview
 3. Chrome에 Obsidian Web Clipper 설치, 저장 폴더를 Clippings/ 로 설정
 4. (터미널이 싫다면) Claude Desktop 앱을 설치하고 vault 폴더를 연결하면
    채팅으로 "클리핑 처리해줘"를 바로 쓸 수 있습니다.
    터미널을 쓴다면: 새 PowerShell에서  cd `$env:VAULT_DIR ; claude
    (첫 실행 시 브라우저 로그인 — 유료 플랜 계정 필요)
 5. 한글(hwp)·워드(docx)·PDF 문서를 위키에 넣으려면 "이 파일 잉게스트해줘"로 요청
    (변환 도구는 이 스크립트가 설치했습니다)

 전체 안내 문서: 팀 위키의 docs/non-developer-onboarding.md
────────────────────────────────────────────
"@
