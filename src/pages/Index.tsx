import DailyDevotional from "@/components/DailyDevotional";
import NotebookSection from "@/components/NotebookSection";

const Index = () => {
  return (
    <div className="min-h-screen bg-background">
      <header className="bg-primary text-primary-foreground py-6 px-4 shadow-md">
        <div className="container mx-auto">
          <h1 className="text-4xl md:text-5xl font-serif text-center">
            Pão Diário
          </h1>
          <p className="text-center text-primary-foreground/80 mt-2">
            Alimento espiritual para sua jornada
          </p>
        </div>
      </header>

      <main className="container mx-auto px-4 py-8 md:py-12">
        <div className="grid gap-8 max-w-4xl mx-auto">
          <DailyDevotional />
          <NotebookSection />
        </div>
      </main>

      <footer className="bg-muted text-muted-foreground py-6 mt-12">
        <div className="container mx-auto text-center px-4">
          <p className="text-sm">
            © {new Date().getFullYear()} Pão Diário. Feito com ❤️ para fortalecer sua fé.
          </p>
        </div>
      </footer>
    </div>
  );
};

export default Index;
