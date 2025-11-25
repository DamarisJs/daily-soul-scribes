import { Card } from "@/components/ui/card";
import { BookOpen } from "lucide-react";

const DailyDevotional = () => {
  return (
    <Card className="p-8 bg-card border-border shadow-lg">
      <div className="flex items-center gap-3 mb-6">
        <BookOpen className="w-8 h-8 text-primary" />
        <div>
          <h2 className="text-3xl font-serif text-foreground">Devocional do Dia</h2>
          <p className="text-muted-foreground text-sm">
            {new Date().toLocaleDateString('pt-BR', { 
              weekday: 'long', 
              year: 'numeric', 
              month: 'long', 
              day: 'numeric' 
            })}
          </p>
        </div>
      </div>

      <div className="space-y-6">
        <div className="border-l-4 border-primary pl-6 py-2">
          <p className="text-sm font-medium text-primary mb-2">João 3:16</p>
          <blockquote className="text-lg italic text-foreground leading-relaxed">
            "Porque Deus amou o mundo de tal maneira que deu o seu Filho unigênito, 
            para que todo aquele que nele crê não pereça, mas tenha a vida eterna."
          </blockquote>
        </div>

        <div className="prose prose-lg max-w-none">
          <h3 className="text-2xl font-serif text-foreground mb-4">Reflexão</h3>
          <p className="text-foreground/90 leading-relaxed mb-4">
            O amor de Deus é incondicional e eterno. Ele não espera que sejamos perfeitos 
            para nos amar. Pelo contrário, é justamente em nossa imperfeição que Seu amor 
            se manifesta de forma mais poderosa.
          </p>
          <p className="text-foreground/90 leading-relaxed mb-4">
            Este versículo nos lembra que o sacrifício de Jesus foi motivado por um amor 
            tão profundo que transcende nossa compreensão humana. É um convite diário para 
            aceitarmos este amor e compartilhá-lo com aqueles ao nosso redor.
          </p>
          <p className="text-foreground/90 leading-relaxed">
            Hoje, reflita sobre como você pode ser um reflexo deste amor incondicional 
            em suas ações, palavras e pensamentos.
          </p>
        </div>
      </div>
    </Card>
  );
};

export default DailyDevotional;
