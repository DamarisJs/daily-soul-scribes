import { useState } from "react";
import { Card } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Textarea } from "@/components/ui/textarea";
import { PenLine, Save, Trash2 } from "lucide-react";
import { useToast } from "@/hooks/use-toast";

interface Note {
  id: string;
  content: string;
  date: string;
}

const NotebookSection = () => {
  const [notes, setNotes] = useState<Note[]>([]);
  const [currentNote, setCurrentNote] = useState("");
  const { toast } = useToast();

  const handleSaveNote = () => {
    if (!currentNote.trim()) {
      toast({
        title: "Atenção",
        description: "Escreva algo antes de salvar.",
        variant: "destructive",
      });
      return;
    }

    const newNote: Note = {
      id: Date.now().toString(),
      content: currentNote,
      date: new Date().toLocaleDateString('pt-BR'),
    };

    setNotes([newNote, ...notes]);
    setCurrentNote("");
    
    toast({
      title: "Reflexão salva!",
      description: "Sua reflexão foi adicionada ao caderno.",
    });
  };

  const handleDeleteNote = (id: string) => {
    setNotes(notes.filter(note => note.id !== id));
    toast({
      title: "Reflexão excluída",
      description: "A reflexão foi removida do caderno.",
    });
  };

  return (
    <Card className="p-8 bg-card border-border shadow-lg">
      <div className="flex items-center gap-3 mb-6">
        <PenLine className="w-8 h-8 text-primary" />
        <h2 className="text-3xl font-serif text-foreground">Meu Caderno</h2>
      </div>

      <div className="space-y-6">
        <div>
          <label className="block text-sm font-medium text-foreground mb-2">
            Escreva sua reflexão pessoal
          </label>
          <Textarea
            value={currentNote}
            onChange={(e) => setCurrentNote(e.target.value)}
            placeholder="O que Deus falou com você hoje?..."
            className="min-h-[150px] resize-none bg-background border-border text-foreground placeholder:text-muted-foreground"
          />
          <Button
            onClick={handleSaveNote}
            className="mt-4 w-full sm:w-auto bg-primary text-primary-foreground hover:bg-primary/90"
          >
            <Save className="w-4 h-4 mr-2" />
            Salvar Reflexão
          </Button>
        </div>

        {notes.length > 0 && (
          <div className="space-y-4 mt-8">
            <h3 className="text-xl font-serif text-foreground">Minhas Reflexões</h3>
            {notes.map((note) => (
              <Card key={note.id} className="p-4 bg-muted/50 border-border">
                <div className="flex justify-between items-start mb-2">
                  <span className="text-sm text-muted-foreground">{note.date}</span>
                  <Button
                    variant="ghost"
                    size="icon"
                    onClick={() => handleDeleteNote(note.id)}
                    className="h-8 w-8 text-destructive hover:text-destructive hover:bg-destructive/10"
                  >
                    <Trash2 className="w-4 h-4" />
                  </Button>
                </div>
                <p className="text-foreground whitespace-pre-wrap">{note.content}</p>
              </Card>
            ))}
          </div>
        )}
      </div>
    </Card>
  );
};

export default NotebookSection;
