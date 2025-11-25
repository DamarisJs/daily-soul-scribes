-- Create devotionals table (public, no auth needed)
CREATE TABLE public.devotionals (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  day_number INTEGER UNIQUE NOT NULL CHECK (day_number >= 1 AND day_number <= 50),
  title TEXT NOT NULL,
  scripture_reference TEXT NOT NULL,
  scripture_text TEXT NOT NULL,
  reflection TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- Enable RLS on devotionals (but allow public read)
ALTER TABLE public.devotionals ENABLE ROW LEVEL SECURITY;

-- Allow anyone to read devotionals
CREATE POLICY "Anyone can read devotionals"
  ON public.devotionals
  FOR SELECT
  USING (true);

-- Create reflections table (requires auth)
CREATE TABLE public.reflections (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  content TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- Enable RLS on reflections
ALTER TABLE public.reflections ENABLE ROW LEVEL SECURITY;

-- Users can only see their own reflections
CREATE POLICY "Users can view their own reflections"
  ON public.reflections
  FOR SELECT
  USING (auth.uid() = user_id);

-- Users can only insert their own reflections
CREATE POLICY "Users can create their own reflections"
  ON public.reflections
  FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- Users can only update their own reflections
CREATE POLICY "Users can update their own reflections"
  ON public.reflections
  FOR UPDATE
  USING (auth.uid() = user_id);

-- Users can only delete their own reflections
CREATE POLICY "Users can delete their own reflections"
  ON public.reflections
  FOR DELETE
  USING (auth.uid() = user_id);

-- Create function to update updated_at timestamp
CREATE OR REPLACE FUNCTION public.update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger for automatic timestamp updates
CREATE TRIGGER update_reflections_updated_at
  BEFORE UPDATE ON public.reflections
  FOR EACH ROW
  EXECUTE FUNCTION public.update_updated_at_column();

-- Insert 50 devotionals
INSERT INTO public.devotionals (day_number, title, scripture_reference, scripture_text, reflection) VALUES
(1, 'O Amor Incondicional', 'João 3:16', 'Porque Deus amou o mundo de tal maneira que deu o seu Filho unigênito, para que todo aquele que nele crê não pereça, mas tenha a vida eterna.', 'O amor de Deus é incondicional e eterno. Ele não espera que sejamos perfeitos para nos amar. Pelo contrário, é justamente em nossa imperfeição que Seu amor se manifesta de forma mais poderosa. Este versículo nos lembra que o sacrifício de Jesus foi motivado por um amor tão profundo que transcende nossa compreensão humana. Hoje, reflita sobre como você pode ser um reflexo deste amor incondicional em suas ações, palavras e pensamentos.'),
(2, 'Fé que Move Montanhas', 'Mateus 17:20', 'Se tiverdes fé como um grão de mostarda, direis a este monte: Passa daqui para acolá, e ele passará. Nada vos será impossível.', 'A fé não precisa ser grande em tamanho, mas precisa ser genuína. Como uma semente de mostarda que cresce e se torna uma grande árvore, nossa fé, mesmo pequena, tem o poder de transformar situações impossíveis. O que parece uma montanha intransponível em sua vida hoje? Confie que com fé, nada é impossível para Deus.'),
(3, 'Paz em Meio à Tempestade', 'João 14:27', 'Deixo-vos a paz, a minha paz vos dou; não vo-la dou como o mundo a dá. Não se turbe o vosso coração, nem se atemorize.', 'Em meio às tempestades da vida, Jesus nos oferece uma paz que vai além do entendimento humano. Essa paz não depende das circunstâncias externas, mas da presença de Cristo em nossos corações. Quando tudo ao redor parecer caótico, lembre-se de que você pode encontrar descanso na paz que só Ele pode dar.'),
(4, 'Força na Fraqueza', '2 Coríntios 12:9', 'A minha graça te basta, porque o meu poder se aperfeiçoa na fraqueza.', 'Nossas fraquezas não são obstáculos para Deus, mas oportunidades para que Sua força se manifeste. Quando reconhecemos nossa fragilidade e dependemos totalmente de Deus, Ele pode trabalhar de maneiras extraordinárias através de nós. Não tenha medo de ser vulnerável diante do Senhor.'),
(5, 'Esperança Renovada', 'Isaías 40:31', 'Os que esperam no Senhor renovam as suas forças, sobem com asas como águias, correm e não se cansam, caminham e não se fatigam.', 'A espera no Senhor não é passiva, mas ativa. É confiar plenamente Nele enquanto seguimos obedecendo e servindo. Aqueles que colocam sua esperança em Deus experimentam renovação constante de suas forças, mesmo nos momentos mais difíceis.'),
(6, 'Perdão Libertador', 'Efésios 4:32', 'Antes sede uns para com os outros benignos, misericordiosos, perdoando-vos uns aos outros, como também Deus vos perdoou em Cristo.', 'O perdão não é apenas um mandamento, mas uma porta para a liberdade. Quando perdoamos, não estamos dizendo que o erro não importou, mas estamos escolhendo não deixar que ele nos aprisione. Assim como Deus nos perdoou gratuitamente, somos chamados a estender esse mesmo perdão aos outros.'),
(7, 'Luz do Mundo', 'Mateus 5:14-16', 'Vós sois a luz do mundo. Não se pode esconder uma cidade situada sobre um monte.', 'Como seguidores de Cristo, somos chamados a ser luz em um mundo de trevas. Isso significa viver de forma que reflita o caráter de Deus, demonstrando amor, justiça e verdade em todas as áreas da vida. Sua luz pode fazer diferença onde você estiver hoje.'),
(8, 'Provisão Divina', 'Filipenses 4:19', 'O meu Deus suprirá todas as vossas necessidades segundo as suas riquezas na glória em Cristo Jesus.', 'Deus conhece cada uma de suas necessidades antes mesmo de você pedir. Ele é fiel para prover não apenas o que você precisa fisicamente, mas também emocionalmente e espiritualmente. Confie que Ele cuidará de você.'),
(9, 'Alegria no Senhor', 'Neemias 8:10', 'A alegria do Senhor é a vossa força.', 'A alegria verdadeira não depende das circunstâncias, mas da presença de Deus em nossa vida. Mesmo nos dias difíceis, podemos encontrar força na alegria que vem do Senhor. Cultive momentos de gratidão e adoração hoje.'),
(10, 'Perseverança na Fé', 'Tiago 1:12', 'Bem-aventurado o homem que suporta a provação, porque, depois de aprovado, receberá a coroa da vida.', 'As provações não vêm para nos destruir, mas para nos fortalecer. Cada desafio superado com fé nos torna mais parecidos com Cristo e nos prepara para as bênçãos que Deus tem reservadas.'),
(11, 'Confiança Plena', 'Provérbios 3:5-6', 'Confia no Senhor de todo o teu coração e não te estribes no teu próprio entendimento.', 'Há momentos em que não entenderemos os caminhos de Deus, mas somos chamados a confiar plenamente Nele. Quando entregamos nossos planos e reconhecemos Sua soberania, Ele dirige nossos passos.'),
(12, 'Paciência e Espera', 'Salmos 27:14', 'Espera no Senhor, anima-te, e ele fortalecerá o teu coração.', 'A espera pode ser difícil, mas é nela que aprendemos a depender de Deus. Enquanto esperamos, Ele trabalha em nós e nas circunstâncias ao nosso redor. Tenha paciência e confiança no tempo perfeito de Deus.'),
(13, 'Sabedoria Celestial', 'Tiago 1:5', 'Se algum de vós tem falta de sabedoria, peça-a a Deus, que a todos dá liberalmente.', 'Deus não esconde Sua sabedoria de nós. Pelo contrário, Ele convida a pedir e promete dar generosamente. Em cada decisão, busque primeiro a direção divina.'),
(14, 'Renovação Diária', 'Lamentações 3:22-23', 'As misericórdias do Senhor são a causa de não sermos consumidos; as suas misericórdias se renovam cada manhã.', 'Cada novo dia é uma oportunidade de experimentar a misericórdia renovada de Deus. Não importa o que aconteceu ontem, hoje você pode começar de novo com a graça e o perdão do Senhor.'),
(15, 'Humildade Verdadeira', 'Filipenses 2:3', 'Nada façais por contenda ou por vanglória, mas por humildade; cada um considere os outros superiores a si mesmo.', 'A humildade não é pensar menos de si mesmo, mas pensar menos em si mesmo. É colocar os outros em primeiro lugar e servir com amor genuíno, assim como Cristo fez.'),
(16, 'Oração Constante', '1 Tessalonicenses 5:17', 'Orai sem cessar.', 'A oração não é apenas um momento específico do dia, mas uma postura constante de comunhão com Deus. Mantenha seu coração aberto ao Senhor em cada momento, compartilhando suas alegrias e preocupações.'),
(17, 'Proteção Divina', 'Salmos 91:4', 'Ele te cobrirá com as suas penas, e debaixo das suas asas te refugiarás.', 'Deus é nosso refúgio e fortaleza. Em Sua presença encontramos segurança verdadeira. Quando tudo parecer incerto, lembre-se de que você está protegido sob as asas do Altíssimo.'),
(18, 'Perdão de Pecados', '1 João 1:9', 'Se confessarmos os nossos pecados, ele é fiel e justo para nos perdoar os pecados e nos purificar de toda injustiça.', 'Deus não apenas perdoa nossos pecados, mas nos purifica completamente. Não carregue o peso da culpa - traga seus erros a Deus e receba Seu perdão total e transformador.'),
(19, 'Comunhão com Irmãos', 'Hebreus 10:24-25', 'Consideremo-nos uns aos outros, para nos estimularmos ao amor e às boas obras.', 'Não fomos criados para caminhar sozinhos. A comunhão com outros cristãos é essencial para nosso crescimento espiritual. Invista em relacionamentos que edifiquem sua fé.'),
(20, 'Propósito Divino', 'Jeremias 29:11', 'Eu é que sei que pensamentos tenho a vosso respeito, diz o Senhor; pensamentos de paz e não de mal, para vos dar o fim que desejais.', 'Deus tem um propósito específico para sua vida. Mesmo quando o caminho parece incerto, confie que Ele está guiando você para um futuro de esperança e paz.'),
(21, 'Santidade', '1 Pedro 1:16', 'Sede santos, porque eu sou santo.', 'Deus nos chama para uma vida de santidade, separada do pecado e dedicada a Ele. Isso não significa perfeição, mas um compromisso diário de buscar Sua vontade e viver de acordo com Seus princípios.'),
(22, 'Generosidade', '2 Coríntios 9:7', 'Deus ama ao que dá com alegria.', 'A generosidade é uma expressão de gratidão a Deus. Quando damos com alegria, refletimos o coração generoso do Pai. Busque oportunidades de abençoar outros hoje.'),
(23, 'Autocontrole', 'Gálatas 5:22-23', 'O fruto do Espírito é: amor, alegria, paz, longanimidade, benignidade, bondade, fidelidade, mansidão, domínio próprio.', 'O autocontrole é fruto do Espírito Santo em nós. À medida que nos rendemos a Ele, desenvolvemos a capacidade de governar nossas emoções, palavras e ações.'),
(24, 'Testemunho Vivo', 'Atos 1:8', 'Sereis minhas testemunhas tanto em Jerusalém como em toda a Judéia e Samaria e até aos confins da terra.', 'Cada um de nós é chamado a ser testemunha de Cristo. Isso começa onde estamos - em nossa casa, trabalho, escola - e se estende a todo lugar onde Deus nos levar.'),
(25, 'Contentamento', 'Filipenses 4:11-12', 'Aprendi a contentar-me com o que tenho.', 'O contentamento não vem de ter tudo o que queremos, mas de reconhecer que tudo o que precisamos está em Cristo. Cultive gratidão pelo que você tem hoje.'),
(26, 'Pureza de Coração', 'Salmos 51:10', 'Cria em mim, ó Deus, um coração puro e renova em mim um espírito reto.', 'Deus deseja transformar nosso coração continuamente. Peça a Ele que remova tudo que não agrada e renove sua mente e espírito diariamente.'),
(27, 'Esperança Eterna', 'Romanos 8:18', 'As aflições deste tempo presente não são para comparar com a glória que em nós há de ser revelada.', 'As dificuldades que enfrentamos hoje são temporárias, mas a glória que nos espera é eterna. Mantenha seus olhos fixos na esperança da eternidade com Cristo.'),
(28, 'Obediência', 'João 14:15', 'Se me amais, guardareis os meus mandamentos.', 'A obediência é a expressão prática do nosso amor por Deus. Quando O amamos verdadeiramente, desejamos agradar-Lhe em todas as áreas da vida.'),
(29, 'Mansidão', 'Mateus 5:5', 'Bem-aventurados os mansos, porque eles herdarão a terra.', 'A mansidão não é fraqueza, mas força sob controle. É escolher responder com gentileza e humildade, mesmo quando poderíamos reagir com dureza.'),
(30, 'Gratidão', '1 Tessalonicenses 5:18', 'Em tudo dai graças, porque esta é a vontade de Deus.', 'A gratidão transforma nossa perspectiva. Mesmo nas situações difíceis, há sempre motivos para agradecer. Cultive um coração grato hoje.'),
(31, 'Fidelidade de Deus', 'Lamentações 3:23', 'Grande é a tua fidelidade.', 'A fidelidade de Deus nunca falha. Ele cumpre todas as Suas promessas e permanece fiel mesmo quando somos infiéis. Descanse na certeza de Seu amor constante.'),
(32, 'Justiça', 'Miquéias 6:8', 'Que pratiques a justiça, e ames a beneficência, e andes humildemente com o teu Deus.', 'Deus nos chama a viver com justiça, demonstrar misericórdia e caminhar humildemente com Ele. Essas três coisas resumem uma vida que agrada ao Senhor.'),
(33, 'Nova Criação', '2 Coríntios 5:17', 'Se alguém está em Cristo, nova criatura é: as coisas velhas já passaram; eis que tudo se fez novo.', 'Em Cristo, você não é definido por seu passado. Você é uma nova criação com um novo começo, uma nova identidade e um novo propósito.'),
(34, 'Compaixão', 'Colossenses 3:12', 'Revesti-vos de profunda compaixão, benignidade, humildade, mansidão e longanimidade.', 'A compaixão nos leva a sentir com os outros e agir para aliviar seu sofrimento. Assim como Cristo teve compaixão de nós, devemos ter compaixão dos outros.'),
(35, 'Palavra Viva', 'Hebreus 4:12', 'A palavra de Deus é viva e eficaz, e mais cortante do que qualquer espada de dois gumes.', 'A Palavra de Deus não é apenas informação, mas transformação. Ela tem poder para mudar vidas, curar feridas e revelar verdades profundas. Dedique tempo para conhecê-la.'),
(36, 'Adoração Verdadeira', 'João 4:24', 'Deus é espírito, e importa que os que o adoram o adorem em espírito e em verdade.', 'A adoração verdadeira vai além de canções e rituais. É uma entrega sincera do coração, reconhecendo quem Deus é e respondendo com amor e reverência.'),
(37, 'Temor do Senhor', 'Provérbios 9:10', 'O temor do Senhor é o princípio da sabedoria.', 'Temer ao Senhor não é ter medo Dele, mas ter reverência profunda e respeito por Sua santidade. É reconhecer Sua grandeza e viver de acordo com Sua vontade.'),
(38, 'Restauração', 'Joel 2:25', 'Restituir-vos-ei os anos que foram consumidos.', 'Deus é especialista em restaurar o que foi perdido ou destruído. Não importa quanto tempo passou, Ele pode redimir e restaurar sua vida de maneiras surpreendentes.'),
(39, 'Fruto do Espírito', 'João 15:5', 'Eu sou a videira, vós, os ramos. Quem permanece em mim, e eu, nele, esse dá muito fruto.', 'Quando permanecemos conectados a Cristo, produzimos fruto naturalmente. Não force, apenas permaneça Nele através da oração, da Palavra e da obediência.'),
(40, 'Santificação', '1 Tessalonicenses 4:3', 'Esta é a vontade de Deus: a vossa santificação.', 'Santificação é o processo contínuo de nos tornarmos mais parecidos com Cristo. É uma jornada diária de crescimento e transformação pelo poder do Espírito Santo.'),
(41, 'Refúgio Seguro', 'Salmos 46:1', 'Deus é o nosso refúgio e fortaleza, socorro bem presente na angústia.', 'Quando tudo parece desabar, Deus permanece firme como nossa rocha. Ele é o refúgio seguro onde podemos encontrar paz e proteção em qualquer tempestade.'),
(42, 'Vida Abundante', 'João 10:10', 'Eu vim para que tenham vida e a tenham em abundância.', 'Jesus não oferece apenas sobrevivência, mas vida plena e abundante. Isso significa propósito, alegria, paz e realização que vêm de um relacionamento com Ele.'),
(43, 'Intercessão', 'Romanos 8:26', 'O Espírito intercede por nós com gemidos inexprimíveis.', 'Mesmo quando não sabemos orar, o Espírito Santo intercede por nós. Você nunca está sozinho em suas orações - Deus compreende o que seu coração não consegue expressar.'),
(44, 'Unidade no Corpo', '1 Coríntios 12:27', 'Vós sois corpo de Cristo; e, individualmente, membros desse corpo.', 'Cada cristão tem um papel único no corpo de Cristo. Quando trabalhamos juntos em unidade, refletimos a beleza e o poder da igreja como Deus a planejou.'),
(45, 'Esperança que não Envergonha', 'Romanos 5:5', 'A esperança não traz confusão, porque o amor de Deus foi derramado em nossos corações.', 'Nossa esperança em Deus nunca nos decepcionará. Diferente das esperanças humanas que falham, a esperança baseada no amor de Deus é sólida e eterna.'),
(46, 'Crescimento Espiritual', '2 Pedro 3:18', 'Crescei na graça e no conhecimento de nosso Senhor Jesus Cristo.', 'O crescimento espiritual é um processo contínuo. Cada dia oferece novas oportunidades de conhecer a Deus mais profundamente e crescer em Sua graça.'),
(47, 'Vigilância', '1 Pedro 5:8', 'Sede sóbrios e vigilantes. O diabo, vosso adversário, anda em derredor, como leão que ruge.', 'A vida cristã requer vigilância constante. Estejamos atentos às tentações e firmes na fé, sabendo que Deus nos dá vitória sobre o inimigo.'),
(48, 'Amor ao Próximo', 'Marcos 12:31', 'Amarás o teu próximo como a ti mesmo.', 'O amor ao próximo é um dos maiores mandamentos. Quando amamos os outros como Cristo nos amou, demonstramos o evangelho de forma prática e poderosa.'),
(49, 'Eternidade no Coração', 'Eclesiastes 3:11', 'Deus pôs a eternidade no coração do homem.', 'Fomos criados com um anseio pela eternidade. As coisas temporais nunca satisfarão completamente porque fomos feitos para algo maior - um relacionamento eterno com Deus.'),
(50, 'Vitória Final', '1 Coríntios 15:57', 'Graças a Deus, que nos dá a vitória por meio de nosso Senhor Jesus Cristo.', 'A vitória final já é nossa em Cristo. Ele venceu o pecado, a morte e o inferno. Vivamos hoje na confiança desta vitória eterna que nos foi dada.');
