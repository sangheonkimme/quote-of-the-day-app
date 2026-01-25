"use client";

export default function PrivacyPolicy() {
  return (
    <main className="min-h-screen bg-muted py-8 px-4">
      <div className="max-w-2xl mx-auto">
        <article className="bg-card rounded-xl p-6 md:p-8 border border-border">
          {/* English Version */}
          <h1 className="text-2xl md:text-3xl font-bold text-foreground mb-2">
            Privacy Policy for Daily Wisdom
          </h1>
          <p className="text-muted-foreground text-sm mb-6">
            Last Updated: January 24, 2025
          </p>

          <section className="mb-8">
            <h2 className="text-xl font-semibold text-foreground mb-3">Overview</h2>
            <p className="text-muted-foreground">
              Daily Wisdom (&quot;the App&quot;) is a simple quote application that respects your privacy.
              This policy explains what data we collect and how we use it.
            </p>
          </section>

          <section className="mb-8">
            <h2 className="text-xl font-semibold text-foreground mb-3">Data Collection</h2>

            <h3 className="text-lg font-medium text-foreground mb-2">Data We DO NOT Collect</h3>
            <ul className="list-disc list-inside text-muted-foreground mb-4 space-y-1">
              <li>Personal information (name, email, phone number)</li>
              <li>Location data</li>
              <li>Contact information</li>
              <li>Photos or files</li>
              <li>Account credentials</li>
            </ul>

            <h3 className="text-lg font-medium text-foreground mb-2">Data Stored Locally</h3>
            <ul className="list-disc list-inside text-muted-foreground space-y-1">
              <li><strong>Liked quotes</strong>: Stored only on your device using local storage</li>
              <li><strong>App preferences</strong>: Language settings stored locally</li>
            </ul>
            <p className="text-muted-foreground mt-2">
              This data never leaves your device and is not transmitted to any server.
            </p>
          </section>

          <section className="mb-8">
            <h2 className="text-xl font-semibold text-foreground mb-3">Third-Party Services</h2>

            <h3 className="text-lg font-medium text-foreground mb-2">Google AdMob</h3>
            <p className="text-muted-foreground mb-2">
              The App displays advertisements through Google AdMob. AdMob may collect:
            </p>
            <ul className="list-disc list-inside text-muted-foreground mb-2 space-y-1">
              <li>Device identifiers for ad personalization</li>
              <li>Ad interaction data</li>
            </ul>
            <p className="text-muted-foreground">
              You can opt out of personalized ads in your device settings. For more information, see{" "}
              <a
                href="https://policies.google.com/privacy"
                target="_blank"
                rel="noopener noreferrer"
                className="text-blue-600 hover:underline"
              >
                Google&apos;s Privacy Policy
              </a>.
            </p>
          </section>

          <section className="mb-8">
            <h2 className="text-xl font-semibold text-foreground mb-3">Children&apos;s Privacy</h2>
            <p className="text-muted-foreground">
              The App does not knowingly collect data from children under 13.
            </p>
          </section>

          <section className="mb-8">
            <h2 className="text-xl font-semibold text-foreground mb-3">Changes to This Policy</h2>
            <p className="text-muted-foreground">
              We may update this policy occasionally. Changes will be posted here with an updated date.
            </p>
          </section>

          <section className="mb-12">
            <h2 className="text-xl font-semibold text-foreground mb-3">Contact</h2>
            <p className="text-muted-foreground">
              For questions about this privacy policy, contact us at:{" "}
              <a href="mailto:railit.biz@gmail.com" className="text-blue-600 hover:underline">
                railit.biz@gmail.com
              </a>
            </p>
          </section>

          <hr className="border-border my-8" />

          {/* Korean Version */}
          <h1 className="text-2xl md:text-3xl font-bold text-foreground mb-2">
            개인정보처리방침 (오늘의 명언)
          </h1>
          <p className="text-muted-foreground text-sm mb-6">
            최종 수정일: 2025년 1월 24일
          </p>

          <section className="mb-8">
            <h2 className="text-xl font-semibold text-foreground mb-3">개요</h2>
            <p className="text-muted-foreground">
              오늘의 명언(&quot;앱&quot;)은 사용자의 개인정보를 존중하는 간단한 명언 앱입니다.
            </p>
          </section>

          <section className="mb-8">
            <h2 className="text-xl font-semibold text-foreground mb-3">수집하는 정보</h2>

            <h3 className="text-lg font-medium text-foreground mb-2">수집하지 않는 정보</h3>
            <ul className="list-disc list-inside text-muted-foreground mb-4 space-y-1">
              <li>개인정보 (이름, 이메일, 전화번호)</li>
              <li>위치 정보</li>
              <li>연락처 정보</li>
              <li>사진 또는 파일</li>
              <li>계정 정보</li>
            </ul>

            <h3 className="text-lg font-medium text-foreground mb-2">기기에 저장되는 정보</h3>
            <ul className="list-disc list-inside text-muted-foreground space-y-1">
              <li><strong>좋아요한 명언</strong>: 기기 내 로컬 저장소에만 저장</li>
              <li><strong>앱 설정</strong>: 언어 설정 등</li>
            </ul>
            <p className="text-muted-foreground mt-2">
              이 데이터는 기기를 벗어나지 않으며 서버로 전송되지 않습니다.
            </p>
          </section>

          <section className="mb-8">
            <h2 className="text-xl font-semibold text-foreground mb-3">제3자 서비스</h2>

            <h3 className="text-lg font-medium text-foreground mb-2">Google AdMob</h3>
            <p className="text-muted-foreground mb-2">
              앱은 Google AdMob을 통해 광고를 표시합니다. AdMob은 다음을 수집할 수 있습니다:
            </p>
            <ul className="list-disc list-inside text-muted-foreground mb-2 space-y-1">
              <li>광고 개인화를 위한 기기 식별자</li>
              <li>광고 상호작용 데이터</li>
            </ul>
            <p className="text-muted-foreground">
              기기 설정에서 맞춤 광고를 거부할 수 있습니다.
            </p>
          </section>

          <section className="mb-8">
            <h2 className="text-xl font-semibold text-foreground mb-3">아동 개인정보</h2>
            <p className="text-muted-foreground">
              앱은 13세 미만 아동의 데이터를 수집하지 않습니다.
            </p>
          </section>

          <section>
            <h2 className="text-xl font-semibold text-foreground mb-3">문의</h2>
            <p className="text-muted-foreground">
              개인정보처리방침에 관한 문의:{" "}
              <a href="mailto:railit.biz@gmail.com" className="text-blue-600 hover:underline">
                railit.biz@gmail.com
              </a>
            </p>
          </section>
        </article>

        <div className="text-center mt-6">
          <a href="/" className="text-muted-foreground hover:text-foreground text-sm">
            ← Back to Home
          </a>
        </div>
      </div>
    </main>
  );
}
