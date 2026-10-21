import { AnnouncementBar } from '@/components/AnnouncementBar';
import { TopNav } from '@/components/TopNav';
import { HeroSection } from '@/components/HeroSection';
import { FeatureCard } from '@/components/FeatureCard';
import { TabSwitcher } from '@/components/TabSwitcher';
import { BtnFilled } from '@/components/BtnFilled';
import { BtnGhost } from '@/components/BtnGhost';
import Link from 'next/link';

export default function HomePage() {
  return (
    <div className="min-h-screen bg-canvas">
      <AnnouncementBar />
      <TopNav />
      <main>
        <HeroSection />
        <section className="max-w-container mx-auto px-6 py-8">
          <div className="grid grid-cols-1 gap-6 sm:grid-cols-2">
            <FeatureCard
              title="Personalized Learning"
              body="Adaptive pathways that meet each student where they are."
            />
            <FeatureCard
              title="Simplify everyday tasks"
              body="Streamline grading, attendance, and classroom workflows."
            />
          </div>
        </section>
        <section className="max-w-container mx-auto px-6 py-8 flex justify-center">
          <TabSwitcher />
        </section>
        <section className="max-w-container mx-auto px-6 py-8">
          <div className="grid grid-cols-1 gap-6 sm:grid-cols-2">
            <FeatureCard
              title="Gain insights and visibility"
              body="Real-time mastery heatmaps and struggle alerts."
            />
            <FeatureCard
              title="Classroom Intelligence"
              body="AI-powered interventions for every learner."
            />
          </div>
        </section>
        <section className="max-w-container mx-auto px-6 py-16 text-center">
          <h2 className="text-heading font-normal text-charcoal mb-4">
            Ready to transform your classroom?
          </h2>
          <div className="flex items-center justify-center gap-4">
            <Link href="/teacher/dashboard">
              <BtnFilled>Teacher Portal</BtnFilled>
            </Link>
            <Link href="/admin/dashboard">
              <BtnGhost>Admin Portal</BtnGhost>
            </Link>
          </div>
        </section>
      </main>
    </div>
  );
}
