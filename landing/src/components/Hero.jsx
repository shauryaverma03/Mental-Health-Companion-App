import { Link } from "react-router-dom";

const Hero = () => {
  return (
    <section id="hero">
      {/* Flex Container */}
      <div className="container flex flex-col-reverse justify-between items-start px-6 mx-auto mt-10 space-y-0 md:space-y-0 md:flex-row">
        {/* Left Item */}
        <div className="flex flex-col mb-32 my-auto space-y-8 md:w-2/3">
          <h1 className="max-w-2xl text-4xl font-bold text-center md:text-5xl md:text-left leading-tight">
            Your Mental Health,
            <br />
            <span className="text-[#0CADB5]">Your Safe Space.</span>
          </h1>

          <p className="max-w-xl text-lg text-center text-gray-600 md:text-left leading-relaxed">
            Saathi is your personal mental wellness companion. Chat with Panda,
            practice mindfulness, explore guided meditation, read empowering
            blogs, and find your calm—all in one place.
          </p>

          <div className="max-w-xl grid grid-cols-1 md:grid-cols-2 gap-4 text-sm">
            <div className="flex items-start gap-3">
              <div className="w-2 h-2 rounded-full bg-[#0CADB5] mt-2 flex-shrink-0"></div>
              <div>
                <h3 className="font-semibold text-gray-800">Chat with Panda</h3>
                <p className="text-gray-600">AI companion available 24/7</p>
              </div>
            </div>

            <div className="flex items-start gap-3">
              <div className="w-2 h-2 rounded-full bg-[#0CADB5] mt-2 flex-shrink-0"></div>
              <div>
                <h3 className="font-semibold text-gray-800">
                  Guided Meditation
                </h3>
                <p className="text-gray-600">Find peace and relaxation</p>
              </div>
            </div>

            <div className="flex items-start gap-3">
              <div className="w-2 h-2 rounded-full bg-[#0CADB5] mt-2 flex-shrink-0"></div>
              <div>
                <h3 className="font-semibold text-gray-800">
                  Breathing Exercises
                </h3>
                <p className="text-gray-600">Calm your mind instantly</p>
              </div>
            </div>

            <div className="flex items-start gap-3">
              <div className="w-2 h-2 rounded-full bg-[#0CADB5] mt-2 flex-shrink-0"></div>
              <div>
                <h3 className="font-semibold text-gray-800">
                  Mental Health Blogs
                </h3>
                <p className="text-gray-600">Learn and grow together</p>
              </div>
            </div>
          </div>

          <div className="flex gap-4 justify-center md:justify-start flex-wrap">
            <Link
              to="/auth"
              className="p-3 px-8 text-white bg-[#0CADB5] rounded-full hover:bg-[#00949c] transition-all duration-300 font-semibold shadow-lg"
            >
              Start Chatting
            </Link>
            <Link
              to="https://github.com/shauryaverma03/Mental-Health-Companion-App"
              className="p-3 px-8 text-[#0CADB5] border-[#0CADB5] border-2 rounded-full hover:bg-green-50 transition-all duration-300 font-semibold"
            >
              Download Now
            </Link>
          </div>
        </div>

        {/* Image */}
        <div className="md:w-1/3 flex items-center justify-center">
          <img
            src="wlc.png"
            className="w-full max-w-md"
            alt="Saathi Mental Health Companion"
          />
        </div>
      </div>
    </section>
  );
};

export default Hero;
